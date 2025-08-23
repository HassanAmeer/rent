import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

class ProfileUpdatePage extends ConsumerStatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  ConsumerState<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends ConsumerState<ProfileUpdatePage> {
  var nameController = TextEditingController(text: "John David");
  var phoneController = TextEditingController(text: "03012345678");
  var emailController = TextEditingController(text: "hasanameer386@gmail.com");
  var aboutController = TextEditingController(
    text: "Avid traveler\nEnjoy mountains and outdoors",
  );
  var addressController = TextEditingController(
    text: "2452 Rooney Rd\nChattanooga , TN 21497",
  );

  bool sendEmails = true;
  bool acceptPrivacy = false;
  bool acceptTerms = false;
  bool isLoading = true;
  bool isUpdating = false;
  bool isPickingImage = false;

  var pikedImage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      isPickingImage = true;
    });
    try {
      var pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          pikedImage = pickedFile.path;
          isPickingImage = false;
        });
      } else {
        setState(() {
          isPickingImage = false;
        });
      }
    } catch (e) {
      setState(() {
        isPickingImage = false;
      });
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 200),
                child: DotLoader(),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Top Row with Profile Image and Edit button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          isPickingImage
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.mainColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Center(child: DotLoader()),
                                )
                              : pikedImage.isNotEmpty
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.mainColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.file(
                                      File(pikedImage),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : CacheImageWidget(
                                  width: 100,
                                  height: 100,
                                  isCircle: true,
                                  radius: 200,
                                  url:
                                      (ref
                                                  .watch(userDataClass)
                                                  .userdata['image'] !=
                                              null &&
                                          ref
                                              .watch(userDataClass)
                                              .userdata['image']
                                              .toString()
                                              .isNotEmpty)
                                      ? Config.imgUrl +
                                            ref
                                                .watch(userDataClass)
                                                .userdata['image']
                                      : ImgLinks.profileImage,
                                ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: () {
                                _showImagePickerOptions(context);
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: aboutController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "About Us",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: const [
                      Text(
                        "Verified By",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "google",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Send Emails",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: sendEmails,
                        onChanged: (value) {
                          setState(() {
                            sendEmails = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Checkbox(
                        value: acceptPrivacy,
                        onChanged: (val) {
                          setState(() {
                            acceptPrivacy = val ?? false;
                          });
                        },
                      ),
                      const Text("I accept the "),
                      GestureDetector(
                        onTap: () {
                          // open privacy policy
                        },
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: acceptTerms,
                        onChanged: (val) {
                          setState(() {
                            acceptTerms = val ?? false;
                          });
                        },
                      ),
                      const Text("Terms and Conditions"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: (acceptPrivacy && acceptTerms && !isUpdating)
                          ? () {
                              ref
                                  .watch(userDataClass)
                                  .updateProfile(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text,
                                    aboutUs: aboutController.text,
                                    address: addressController.text,
                                    imagePath: pikedImage,
                                  );
                            }
                          : null,
                      child: ref.watch(userDataClass).isLoading
                          ? const DotLoader()
                          : const Text(
                              "Update Profile",
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
