import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/profile_update_page.dart' hide ProfileUpdatePage;
import 'package:rent/apidata/user.dart' show userDataClass;
// import 'package:rent/auth/login.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/Auth/login.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
// import '../apidata/user.dart';
import '../widgets/btmnavbar.dart';
// import '../apidata/user.dart';
// import '../constants/data.dart';
import '../design/home_page.dart';
// import '../widgets/casheimage.dart';
import 'profile_update_page.dart';
// import '../widgets/btmnavbar.dart';

class ProfileDetailsPage extends ConsumerStatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  ConsumerState<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends ConsumerState<ProfileDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(userDataClass).getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ref.watch(userDataClass).isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 200),
                child: DotLoader(),
              ),
            )
          : ref.watch(userDataClass).userdata.isEmpty
          ? const Center(child: Text("Failed to load user data"))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    // ClipRRect(
                    //   borderRadius: const BorderRadius.all(
                    //     Radius.circular(100),
                    //   ),
                    //   child: CircleAvatar(
                    //     radius: 50,
                    //     backgroundImage: NetworkImage(
                    //       Config.imgUrl +
                    //               ref.watch(userDataClass).userdata['image'] ??
                    //           imgLinks.profileImage,
                    //     ),
                    //   ),
                    // ),
                    CacheImageWidget(
                      width: 100,
                      height: 100,
                      isCircle: true,
                      radius: 200,
                      url:
                          (ref.watch(userDataClass).userdata['image'] != null &&
                              ref
                                  .watch(userDataClass)
                                  .userdata['image']
                                  .toString()
                                  .isNotEmpty)
                          ? Config.imgUrl +
                                ref.watch(userDataClass).userdata['image']
                          : ImgLinks.profileImage,
                    ),

                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        ref.watch(userDataClass).userdata['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    CupertinoListTile(
                      title: const Text(
                        "Email",
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      subtitle: Text(
                        ref.watch(userDataClass).userdata['email'] ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Divider(),
                    CupertinoListTile(
                      title: const Text(
                        "Phone Number",
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      subtitle: Text(
                        ref.watch(userDataClass).userdata['phone'] ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Divider(),
                    CupertinoListTile(
                      title: const Text(
                        "Address",
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      subtitle: Text(
                        ref.watch(userDataClass).userdata['address'] ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Divider(),
                    CupertinoListTile(
                      title: const Text(
                        "About Us",
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      subtitle: Text(
                        ref.watch(userDataClass).userdata['aboutUs'] ?? 'empty',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          ref.watch(userDataClass).logout();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Logout",
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.exit_to_app, color: Colors.deepOrange),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.black,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileUpdatePage()),
          );
        },
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 4),
    );
  }
}
