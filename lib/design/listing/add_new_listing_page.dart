import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_html_editor/fl_html_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rent/apidata/listingapi.dart';
import 'package:rent/apidata/categoryapi.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/custom_image_text_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../widgets/mediadropdown.dart';

class AddNewListingPage extends ConsumerStatefulWidget {
  const AddNewListingPage({super.key});

  @override
  ConsumerState<AddNewListingPage> createState() => _AddNewListingPageState();
}

class _AddNewListingPageState extends ConsumerState<AddNewListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  HtmlEditorController _descriptionHTMLController = HtmlEditorController();
  final _dailyRateController = TextEditingController();
  final _weeklyRateController = TextEditingController();
  final _monthlyRateController = TextEditingController();

  String? _selectedCategory;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // Availability Days Selection
  Map<String, Map<String, TimeOfDay?>> _availabilitySchedule = {};
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

  // Remove initState - categories will be loaded on demand

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dailyRateController.dispose();
    _weeklyRateController.dispose();
    _monthlyRateController.dispose();
    super.dispose();
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

  Future<TimeOfDay?> _selectTime(BuildContext context, String title) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: title,
    );
  }

  void _toggleDayAvailability(String day, bool isAvailable) {
    setState(() {
      if (isAvailable) {
        _availabilitySchedule[day] = {'start': null, 'end': null};
      } else {
        _availabilitySchedule.remove(day);
      }
    });
  }

  Future<void> _setDayTime(String day, String timeType) async {
    final TimeOfDay? pickedTime = await _selectTime(
      context,
      'Select ${timeType == 'start' ? 'Start' : 'End'} Time for $day',
    );

    if (pickedTime != null) {
      setState(() {
        _availabilitySchedule[day] ??= {'start': null, 'end': null};
        _availabilitySchedule[day]![timeType] = pickedTime;
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _generateAvailabilityString() {
    if (_availabilitySchedule.isEmpty) return '';

    List<String> availabilityParts = [];

    for (var entry in _availabilitySchedule.entries) {
      final day = entry.key;
      final times = entry.value;
      final startTime = times['start'];
      final endTime = times['end'];

      if (startTime != null && endTime != null) {
        final startStr = _formatTime(startTime);
        final endStr = _formatTime(endTime);
        availabilityParts.add('$day: $startStr To $endStr');
      }
    }

    return availabilityParts.join(',');
  }

  Future<void> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
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
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
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

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image removed!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// ✅ Form Submit with API Call
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null || _selectedCategory!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a category'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final listingApi = ref.read(listingDataProvider);
        final userId =
            ref.read(userDataClass).userData['id']?.toString() ?? '1';

        await listingApi.addNewListing(
          uid: userId,
          title: _titleController.text.trim(),
          catgname: _selectedCategory ?? "",
          dailyRate: _dailyRateController.text.trim().isEmpty
              ? "0"
              : _dailyRateController.text.trim(),
          weeklyRate: _weeklyRateController.text.trim().isEmpty
              ? "0"
              : _weeklyRateController.text.trim(),
          monthlyRate: _monthlyRateController.text.trim().isEmpty
              ? "0"
              : _monthlyRateController.text.trim(),
          availabilityDays: _generateAvailabilityString(),
          description: _descriptionHTMLController.getHtml().toString(),
          images: _selectedImages,
          loadingFor: "uploadData",
        );

        ref
            .watch(listingDataProvider)
            .fetchMyItems(
              uid: ref.watch(userDataClass).userData["id"].toString(),
              search: "",
              loadingfor: "123",
            );
        if (!mounted) return;

        _titleController.clear();
        _descriptionController.clear();
        _descriptionHTMLController.clear();
        _dailyRateController.clear();
        _weeklyRateController.clear();
        _monthlyRateController.clear();

        setState(() {
          _selectedCategory = null;
          _selectedImages.clear();
          _availabilitySchedule.clear();
        });

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          toast('Error: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final listingApi = ref.watch(listingDataProvider);
    final categoryApi = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add New Listing',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black12,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Section with Animation
              _buildSectionLabel('Category')
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms),
              const SizedBox(height: 8),

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
                hint: 'Select an option',
                onSelected: (index, value) {
                  print('Selected index: $index, value: $value');
                },
                onTap: (index) {
                  print('Item tapped: $index');
                },
                onArrowTap: () async {
                  print('Arrow tapped:');
                  // if (!categoryApi.hasLoaded) {
                  await ref
                      .read(categoryProvider)
                      .fetchCategories(loadingFor: "category");
                  // .fetchCategoriesIfNeeded(loadingFor: "category");
                  // }
                },
                isLoading: ref.watch(categoryProvider).loadingFor == "category",
                titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                subtitleStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                ),
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                dropdownBackgroundColor: Colors.white,
                width: double.infinity,
                // height: 70,
                elevation: 4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),

              Container(
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
                    child: categoryApi.loadingFor == "category"
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Loading categories...'),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              if (!categoryApi.hasLoaded) {
                                await ref
                                    .read(categoryProvider)
                                    .fetchCategoriesIfNeeded(
                                      loadingFor: "category",
                                    );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedCategory?.isNotEmpty == true
                                          ? _selectedCategory!
                                          : 'Select a category',
                                      style: TextStyle(
                                        color:
                                            _selectedCategory?.isNotEmpty ==
                                                true
                                            ? Colors.black
                                            : Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
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

              _buildSectionLabel('Item Title')
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms),
              const SizedBox(height: 8),
              _buildTextField(
                    controller: _titleController,
                    hintText: 'Enter product title',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter item title'
                        : null,
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 250.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms)
                  .scale(
                    begin: Offset(0.95, 0.95),
                    end: Offset(1, 1),
                    duration: 300.ms,
                  ),
              const SizedBox(height: 20),

              _buildSectionLabel('Item Description')
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms),
              const SizedBox(height: 8),

              // _buildTextField(
              //       controller: _descriptionController,
              //       hintText: 'Enter description',
              //       validator: (value) => value == null || value.isEmpty
              //           ? 'Please enter item description'
              //           : null,
              //     )
              //     .animate()
              //     .fadeIn(duration: 400.ms, delay: 350.ms)
              //     .slideX(begin: -0.2, end: 0, duration: 500.ms)
              //     .scale(
              //       begin: Offset(0.95, 0.95),
              //       end: Offset(1, 1),
              //       duration: 300.ms,
              //     ),
              HtmlEditor(
                    controller: _descriptionHTMLController,
                    height: 270,
                    settings: EditorSettings(placeholder: "Description"),
                    onChanged: (content) {
                      debugPrint('Content changed: $content');
                    },
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 350.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms)
                  .scale(
                    begin: Offset(0.95, 0.95),
                    end: Offset(1, 1),
                    duration: 300.ms,
                  ),

              const SizedBox(height: 20),

              _buildSectionLabel('Images')
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 400.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms),
              const SizedBox(height: 8),
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
                          child:
                              ElevatedButton.icon(
                                    onPressed: _pickImages,
                                    icon: const Icon(Icons.add_photo_alternate),
                                    label: const Text('Add New Image'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.mainColor
                                          .withOpacity(0.1),
                                      foregroundColor: AppColors.mainColor,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: AppColors.mainColor
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 300.ms, delay: 450.ms)
                                  .scale(
                                    begin: Offset(0.95, 0.95),
                                    end: Offset(1, 1),
                                    duration: 300.ms,
                                  ),
                        ),
                        if (_selectedImages.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Selected Images (${_selectedImages.length})',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.file(
                                              _selectedImages[index],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          .animate()
                                          .fadeIn(
                                            duration: 400.ms,
                                            delay: Duration(
                                              milliseconds: 550 + (index * 100),
                                            ),
                                          )
                                          .scale(
                                            begin: Offset(0.8, 0.8),
                                            end: Offset(1, 1),
                                            duration: 300.ms,
                                          ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child:
                                            GestureDetector(
                                              onTap: () => _removeImage(index),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(
                                                    0.9,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ).animate().fadeIn(
                                              duration: 300.ms,
                                              delay: Duration(
                                                milliseconds:
                                                    600 + (index * 100),
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
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 450.ms)
                  .slideY(begin: 0.1, end: 0, duration: 500.ms),
              const SizedBox(height: 20),

              _buildSectionLabel('Availability Schedule')
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 500.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms),
              const SizedBox(height: 8),
              Container(
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
                      children: _daysOfWeek.map((day) {
                        final isAvailable = _availabilitySchedule.containsKey(
                          day,
                        );
                        final startTime = _availabilitySchedule[day]?['start'];
                        final endTime = _availabilitySchedule[day]?['end'];

                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                day,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Switch(
                                value: isAvailable,
                                onChanged: (value) =>
                                    _toggleDayAvailability(day, value),
                                activeColor: AppColors.mainColor,
                                activeTrackColor: AppColors.mainColor
                                    .withOpacity(0.3),
                              ),
                            ).animate().fadeIn(
                              duration: 300.ms,
                              delay: Duration(
                                milliseconds:
                                    550 + (_daysOfWeek.indexOf(day) * 50),
                              ),
                            ),
                            if (isAvailable) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => _setDayTime(day, 'start'),
                                        child:
                                            Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                        horizontal: 16,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: startTime != null
                                                          ? AppColors.mainColor
                                                                .withOpacity(
                                                                  0.5,
                                                                )
                                                          : Colors.grey[300]!,
                                                      width: startTime != null
                                                          ? 2
                                                          : 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: startTime != null
                                                        ? AppColors.mainColor
                                                              .withOpacity(0.05)
                                                        : Colors.grey[50],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Start: ${_formatTime(startTime)}',
                                                        style: TextStyle(
                                                          color:
                                                              startTime != null
                                                              ? AppColors
                                                                    .mainColor
                                                              : Colors.grey,
                                                          fontWeight:
                                                              startTime != null
                                                              ? FontWeight.w600
                                                              : FontWeight
                                                                    .normal,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.access_time,
                                                        size: 22,
                                                        color: startTime != null
                                                            ? AppColors
                                                                  .mainColor
                                                            : Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                .animate()
                                                .fadeIn(
                                                  duration: 300.ms,
                                                  delay: Duration(
                                                    milliseconds:
                                                        600 +
                                                        (_daysOfWeek.indexOf(
                                                              day,
                                                            ) *
                                                            50),
                                                  ),
                                                )
                                                .slideX(
                                                  begin: -0.1,
                                                  end: 0,
                                                  duration: 300.ms,
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => _setDayTime(day, 'end'),
                                        child:
                                            Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                        horizontal: 16,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: endTime != null
                                                          ? AppColors.mainColor
                                                                .withOpacity(
                                                                  0.5,
                                                                )
                                                          : Colors.grey[300]!,
                                                      width: endTime != null
                                                          ? 2
                                                          : 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: endTime != null
                                                        ? AppColors.mainColor
                                                              .withOpacity(0.05)
                                                        : Colors.grey[50],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'End: ${_formatTime(endTime)}',
                                                        style: TextStyle(
                                                          color: endTime != null
                                                              ? AppColors
                                                                    .mainColor
                                                              : Colors.grey,
                                                          fontWeight:
                                                              endTime != null
                                                              ? FontWeight.w600
                                                              : FontWeight
                                                                    .normal,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.access_time,
                                                        size: 22,
                                                        color: endTime != null
                                                            ? AppColors
                                                                  .mainColor
                                                            : Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                .animate()
                                                .fadeIn(
                                                  duration: 300.ms,
                                                  delay: Duration(
                                                    milliseconds:
                                                        650 +
                                                        (_daysOfWeek.indexOf(
                                                              day,
                                                            ) *
                                                            50),
                                                  ),
                                                )
                                                .slideX(
                                                  begin: 0.1,
                                                  end: 0,
                                                  duration: 300.ms,
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (day != _daysOfWeek.last)
                              Divider(height: 1, color: Colors.grey[200]),
                          ],
                        );
                      }).toList(),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 550.ms)
                  .slideY(begin: 0.1, end: 0, duration: 500.ms),
              const SizedBox(height: 20),

              _buildSectionLabel('Pricing')
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 600.ms)
                  .slideX(begin: -0.2, end: 0, duration: 500.ms),
              const SizedBox(height: 8),
              Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              _buildTextField(
                                    controller: _dailyRateController,
                                    hintText: 'Daily rate',
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: AppColors.mainColor,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 300.ms, delay: 650.ms)
                                  .slideY(begin: 0.1, end: 0, duration: 400.ms),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child:
                              _buildTextField(
                                    controller: _weeklyRateController,
                                    hintText: 'Weekly rate',
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icon(
                                      Icons.calendar_view_week,
                                      color: AppColors.mainColor,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 300.ms, delay: 700.ms)
                                  .slideY(begin: 0.1, end: 0, duration: 400.ms),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child:
                              _buildTextField(
                                    controller: _monthlyRateController,
                                    hintText: 'Monthly rate',
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icon(
                                      Icons.calendar_month,
                                      color: AppColors.mainColor,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 300.ms, delay: 750.ms)
                                  .slideY(begin: 0.1, end: 0, duration: 400.ms),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 650.ms)
                  .slideY(begin: 0.1, end: 0, duration: 500.ms),
              const SizedBox(height: 30),

              // ✅ Enhanced Button with Animation
              Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mainColor,
                          AppColors.mainColor.withOpacity(0.8),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: listingApi.loadingfor == "uploadData"
                          ? null
                          : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: listingApi.loadingfor == "uploadData"
                            ? Colors.grey
                            : Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: listingApi.loadingfor == "uploadData"
                          ? const DotLoader()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.upload_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Add Item',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 800.ms)
                  .slideY(begin: 0.2, end: 0, duration: 500.ms)
                  .scale(
                    begin: Offset(0.95, 0.95),
                    end: Offset(1, 1),
                    duration: 300.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? prefixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
