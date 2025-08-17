import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/constants/goto.dart';

import '../../apidata/listingapi.dart';
import '../../apidata/user.dart';
import '../../constants/toast.dart';

class EditListingPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> itemData;

  const EditListingPage({super.key, required this.itemData});

  @override
  ConsumerState<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends ConsumerState<EditListingPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dailyRateController = TextEditingController();
  final TextEditingController _weeklyRateController = TextEditingController();
  final TextEditingController _monthlyRateController = TextEditingController();
  final TextEditingController _availiablityDaysController = TextEditingController();
  final List<String> _selectedImages = [];
  String? _selectedCategory = "Electronics";
  bool _isLoading = false;

  final List<String> _categories = [
    'Electronics',
    'Furniture',
    'Vehicles',
    'Tools & Equipment',
    'Sports & Recreation',
    'Clothing & Accessories',
    'Books & Media',
    'Home & Garden',
    'Musical Instruments',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.itemData['title'] ?? '',
    );
    // _descriptionController = TextEditingController(
    //   text: widget.itemData['description'] ?? '',
    // );
    // _dailyRateController = TextEditingController(
    //   text: widget.itemData['dailyrate']?.toString() ?? '0',
    // );
    // _weeklyRateController = TextEditingController(
    //   text: widget.itemData['weeklyrate']?.toString() ?? '0',
    // );
    // _monthlyRateController = TextEditingController(
    //   text: widget.itemData['monthlyrate']?.toString() ?? '0',
    // );
    // // _selectedCategory = widget.itemData['category'] ?? _categories.first;
    // _selectedImages = List.from(widget.itemData['images'] ?? []);
  }

  Future<void> _pickImages() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(pickedFile.path);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Lisfgting")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
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

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
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
                    TextFormField(
                      controller: _availiablityDaysController,
                      keyboardType: TextInputType.text,
                      // minLines: 3,
                      // maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Availibilty Days',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Images
                    Text(
                      'Images',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: _selectedImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(Icons.add_a_photo),
                              ),
                            ),
                          );
                        }
                        final imageIndex = index - 1;
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image:
                                      _selectedImages[imageIndex].startsWith(
                                        'http',
                                      )
                                      ? NetworkImage(
                                          Config.imgUrl +
                                              _selectedImages[imageIndex],
                                        )
                                      : FileImage(
                                              File(_selectedImages[imageIndex]),
                                            )
                                            as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(imageIndex),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            // Prepare data for update
                            final updatedData = {
                              'title': _titleController.text,
                              'description': _descriptionController.text,
                              'avalibilityDays':
                                  _availiablityDaysController.text,
                              'dailyrate': _dailyRateController.text,
                              'weeklyrate': _weeklyRateController.text,
                              'monthlyrate': _monthlyRateController.text,
                              'category': _selectedCategory,
                              'images': _selectedImages,
                            };

                            // Call the API to update the listing
                            ref
                                .read(listingDataProvider)
                                .editsmyitems(
                                  itemId: widget.itemData['id'].toString(),
                                  uid: ref
                                      .watch(userDataClass)
                                      .userdata['id']
                                      .toString(),
                                  newItemData: updatedData,
                                )
                                .then((_) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pop(context);
                                })
                                .catchError((error) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  toast('Error updating listing: $error');
                                });
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
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
