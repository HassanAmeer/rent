import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/widgets/casheimage.dart';

class EditListingPage extends StatefulWidget {
  final Map<String, dynamic>? listingData; // Safe nullable

  const EditListingPage({super.key, required this.listingData});

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dailyRateController;
  late TextEditingController weeklyRateController;
  late TextEditingController monthlyRateController;
  late TextEditingController availabilityDaysController;

  String pickedImgPath = "";

  @override
  void initState() {
    super.initState();

    final data = widget.listingData ?? {};

    titleController = TextEditingController(
      text: (data['title'] ?? '').toString(),
    );
    descriptionController = TextEditingController(
      text: (data['description'] ?? '').toString(),
    );
    dailyRateController = TextEditingController(
      text: (data['dailyrate'] ?? '').toString(),
    );
    weeklyRateController = TextEditingController(
      text: (data['weeklyrate'] ?? '').toString(),
    );
    monthlyRateController = TextEditingController(
      text: (data['monthlyrate'] ?? '').toString(),
    );
    availabilityDaysController = TextEditingController(
      text: (data['availabilityDays'] ?? '').toString(),
    );
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        pickedImgPath = pickedFile.path;
      });
    }
  }

  void updateListing() {
    debugPrint("Updating Listing...");
    debugPrint("Title: ${titleController.text}");
    debugPrint("Description: ${descriptionController.text}");
    debugPrint("Daily Rate: ${dailyRateController.text}");
    debugPrint("Weekly Rate: ${weeklyRateController.text}");
    debugPrint("Monthly Rate: ${monthlyRateController.text}");
    debugPrint("Availability Days: ${availabilityDaysController.text}");
    debugPrint("Image Path: $pickedImgPath");

    // TODO: API call here
  }

  @override
  Widget build(BuildContext context) {
    final imgList = widget.listingData?['images'] as List? ?? [];
    final imgUrl = imgList.isNotEmpty
        ? Config.imgUrl + (imgList.first ?? imgLinks.profileImage)
        : imgLinks.profileImage;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Listing",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Image Picker
            Row(
              children: [
                Stack(
                  children: [
                    pickedImgPath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(pickedImgPath),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CacheImageWidget(
                            width: 120,
                            height: 120,
                            isCircle: false,
                            radius: 10,
                            url: imgUrl,
                          ),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: InkWell(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.black,
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                const Text(
                  "Change Image",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Description
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Daily Rate
            TextField(
              controller: dailyRateController,
              decoration: InputDecoration(
                labelText: "Daily Rate",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),

            // Weekly Rate
            TextField(
              controller: weeklyRateController,
              decoration: InputDecoration(
                labelText: "Weekly Rate",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),

            // Monthly Rate
            TextField(
              controller: monthlyRateController,
              decoration: InputDecoration(
                labelText: "Monthly Rate",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),

            // Availability Days
            TextField(
              controller: availabilityDaysController,
              decoration: InputDecoration(
                labelText: "Availability Days",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Update Button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: updateListing,
                child: const Text(
                  "Update Listing",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
