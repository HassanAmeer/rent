import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/models/item_model.dart';
import 'dart:developer' as dev;
import 'package:fl_html_editor/fl_html_editor.dart';
import 'package:rent/apidata/categoryapi.dart';

// import '../../apidata/listingapi.dart';
// import '../../apidata/user.dart';
import '../../apidata/listingapi.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/toast.dart';
import '../../widgets/mediadropdown.dart';

class EditListingPage extends ConsumerStatefulWidget {
  final ItemModel item;

  const EditListingPage({super.key, required this.item});

  @override
  ConsumerState<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends ConsumerState<EditListingPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late HtmlEditorController _descriptionHTMLController;
  late TextEditingController _dailyRateController;
  late TextEditingController _weeklyRateController;
  late TextEditingController _monthlyRateController;
  late TextEditingController _availiablityDaysController;
  late List<String> _existingImages;
  late List<String> _newImages;
  int? _selectedCategoryId = 00;

  // Availability Schedule Management
  late Map<String, Map<String, TimeOfDay?>> _availabilitySchedule;
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Categories will be loaded from API

  // Categories will be loaded from API

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.displayTitle);
    _descriptionController = TextEditingController(
      text: widget.item.description ?? '',
    );
    _descriptionHTMLController = HtmlEditorController();
    _dailyRateController = TextEditingController(
      text: widget.item.dailyRate.toString(),
    );
    _weeklyRateController = TextEditingController(
      text: widget.item.weeklyRate.toString(),
    );
    _monthlyRateController = TextEditingController(
      text: widget.item.monthlyRate.toString(),
    );
    _availiablityDaysController = TextEditingController(
      text: widget.item.availabilityDays ?? '',
    );
    _selectedCategoryId = widget.item.categoryId ?? 0;
    _existingImages = List.from(widget.item.images);
    _newImages = [];

    // Initialize availability schedule
    dev.log('Availability String: ${widget.item.availabilityDays}');
    _availabilitySchedule = _parseAvailabilitySchedule(
      widget.item.availabilityDays,
    );
    dev.log('Parsed Schedule: $_availabilitySchedule');

    // Fetch categories and set HTML content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryProvider).fetchCategories();
      _descriptionHTMLController.setHtml(widget.item.description ?? '');
    });
  }

  // Parse availability days string into schedule map
  Map<String, Map<String, TimeOfDay?>> _parseAvailabilitySchedule(
    String? availabilityString,
  ) {
    final schedule = <String, Map<String, TimeOfDay?>>{};

    // Initialize with default empty schedule
    for (final day in _daysOfWeek) {
      schedule[day] = {'start': null, 'end': null};
    }

    if (availabilityString == null || availabilityString.isEmpty) {
      return schedule;
    }

    // Parse the availability string (format: "Monday: 09:00 To 17:00,Tuesday: 10:00 To 18:00")
    final dayEntries = availabilityString.split(',');
    for (final entry in dayEntries) {
      final trimmedEntry = entry.trim();
      if (trimmedEntry.isEmpty) continue;

      final colonIndex = trimmedEntry.indexOf(':');
      if (colonIndex == -1) continue;

      final day = trimmedEntry.substring(0, colonIndex).trim();
      final timePart = trimmedEntry.substring(colonIndex + 1).trim();

      TimeOfDay? startTime;
      TimeOfDay? endTime;

      if (timePart.contains('To')) {
        final timeParts = timePart.split('To');
        if (timeParts.length == 2) {
          startTime = _parseTimeString(timeParts[0].trim());
          endTime = _parseTimeString(timeParts[1].trim());
        }
      }

      if (_daysOfWeek.contains(day)) {
        schedule[day] = {'start': startTime, 'end': endTime};
      }
    }

    return schedule;
  }

  // Parse time string like "09:00" or "9:00 AM" into TimeOfDay
  TimeOfDay? _parseTimeString(String timeString) {
    try {
      // Handle formats like "09:00", "9:00 AM", "9:00 PM"
      final cleanTime = timeString.replaceAll(RegExp(r'\s*(AM|PM|am|pm)'), '');
      final parts = cleanTime.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      debugPrint('Error parsing time: $timeString');
    }
    return null;
  }

  Future<void> _pickImages() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _newImages.add(image.path);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image added from gallery!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _getImageFromCamera() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      setState(() {
        _newImages.add(image.path);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image captured from camera!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  // Availability Schedule Methods
  void _toggleDayAvailability(String day, bool isAvailable) {
    setState(() {
      if (isAvailable) {
        _availabilitySchedule[day] = {
          'start': const TimeOfDay(hour: 9, minute: 0),
          'end': const TimeOfDay(hour: 17, minute: 0),
        };
      } else {
        _availabilitySchedule[day] = {'start': null, 'end': null};
      }
    });
  }

  Future<void> _setDayTime(String day, String type) async {
    final initialTime = _availabilitySchedule[day]![type];
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? const TimeOfDay(hour: 9, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        _availabilitySchedule[day]![type] = pickedTime;
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _buildAvailabilityString() {
    final availableDays = <String>[];

    for (final day in _daysOfWeek) {
      final schedule = _availabilitySchedule[day];
      final startTime = schedule!['start'];
      final endTime = schedule['end'];

      if (startTime != null && endTime != null) {
        availableDays.add(
          '$day: ${_formatTime(startTime)} To ${_formatTime(endTime)}',
        );
      }
    }

    return availableDays.join(',');
  }

  Widget _buildDayAvailabilityRow(String day) {
    final schedule = _availabilitySchedule[day]!;
    final startTime = schedule['start'];
    final endTime = schedule['end'];
    final isAvailable = startTime != null && endTime != null;
    dev.log(
      'Day: $day, Start: $startTime, End: $endTime, Available: $isAvailable',
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Switch(
                value: isAvailable,
                onChanged: (value) => _toggleDayAvailability(day, value),
                activeColor: Colors.cyan,
              ),
            ],
          ),
          if (isAvailable) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setDayTime(day, 'start'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.cyan,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Start: ${_formatTime(startTime)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setDayTime(day, 'end'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'End: ${_formatTime(endTime)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final categoryApi = ref.watch(categoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Listing")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // category
              MediaDropdown(
                    items: ref
                        .watch(categoryProvider)
                        .categories
                        .map(
                          (e) => DropdownItem(
                            title: e.name,
                            subtitle: e.id.toString(),
                            image: CachedNetworkImage(imageUrl: e.fullImageUrl),
                            value: e.name,
                          ),
                        )
                        .toList(),
                    hint: 'Select an Category',

                    initalSelectedValue: _selectedCategoryId != null
                        ? ref
                                  .watch(categoryProvider)
                                  .categories
                                  .where((e) => e.id == _selectedCategoryId)
                                  .isNotEmpty
                              ? ref
                                    .watch(categoryProvider)
                                    .categories
                                    .firstWhere(
                                      (e) => e.id == _selectedCategoryId,
                                    )
                                    .id
                              : null
                        : null,
                    onSelected: (index, value) {
                      // print('Selected index: $index, value: $value');
                      _selectedCategoryId = ref
                          .watch(categoryProvider)
                          .categories[index]
                          .id;
                    },
                    onTap: (index) {
                      print('Item tapped: $index');
                    },
                    onArrowTap: () async {
                      await ref
                          .read(categoryProvider)
                          .fetchCategories(loadingFor: "category");
                    },
                    isLoading:
                        ref.watch(categoryProvider).loadingFor == "category",
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    dropdownBackgroundColor: Colors.white,
                    width: double.infinity,
                    // height: 70,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 150.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms)
                  .scale(
                    begin: Offset(0.95, 0.95),
                    end: Offset(1, 1),
                    duration: 300.ms,
                  ),

              const SizedBox(height: 20),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Description with HTML Editor
              HtmlEditor(
                controller: _descriptionHTMLController,
                height: 270,
                settings: EditorSettings(placeholder: "Description"),
                onChanged: (content) {
                  debugPrint('Content changed: $content');
                },
              ),

              const SizedBox(height: 20),

              // Pricing
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dailyRateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Daily Rate',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _weeklyRateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weekly Rate',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _monthlyRateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monthly Rate',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),

              const SizedBox(height: 20),

              // Availability Schedule Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Availability Schedule',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._daysOfWeek.map((day) => _buildDayAvailabilityRow(day)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Images
              Text('Images', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Add New Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.withOpacity(0.1),
                          foregroundColor: Colors.cyan,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.cyan.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // New Images
                    if (_newImages.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'New Images (${_newImages.length})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _newImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(_newImages[index]),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeNewImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.9),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    // Existing Images
                    if (_existingImages.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Existing Images',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _existingImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          _existingImages[index].startsWith(
                                            'http',
                                          )
                                          ? _existingImages[index]
                                          : Api.imgPath +
                                                _existingImages[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.image_not_supported,
                                            ),
                                          ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeExistingImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.9),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final availabilityString = _buildAvailabilityString();

                      final updatedData = {
                        'title': _titleController.text.trim(),
                        'description': _descriptionHTMLController
                            .getHtml()
                            .toString(),
                        'avalibilityDays': availabilityString,
                        'dailyrate': _dailyRateController.text.trim(),
                        'weeklyrate': _weeklyRateController.text.trim(),
                        'monthlyrate': _monthlyRateController.text.trim(),
                        'category': _selectedCategoryId,
                        'newImages': _newImages,
                        'existingImages': _existingImages
                            .map((e) => e.toString().split("uploads/").last)
                            .toList(),
                      };

                      dev.log('Updated Data: $updatedData');

                      ref
                          .read(listingDataProvider)
                          .editsmyitems(
                            itemId: widget.item.id.toString(),
                            uid: ref
                                .watch(userDataClass)
                                .userData['id']
                                .toString(),
                            newItemData: updatedData,
                          );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Update Listing',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
