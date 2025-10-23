import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/profile_update_page.dart' hide ProfileUpdatePage;
import 'package:rent/apidata/user.dart' show userDataClass;
// import 'package:rent/auth/login.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/Auth/login.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:transparent_route/transparent_route.dart';
// import '../apidata/user.dart';
import '../constants/api_endpoints.dart';
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
      // appBar: AppBar(
      //   title: const Text("My Profile", style: TextStyle(color: Colors.black)),
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.white,
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              const SizedBox(height: 70),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  pushScreen(
                    context,
                    Profileview(
                      imagelink:
                          (ref.watch(userDataClass).userData['image'] != null &&
                              ref
                                  .watch(userDataClass)
                                  .userData['image']
                                  .toString()
                                  .isNotEmpty)
                          ? Api.imgPath +
                                ref.watch(userDataClass).userData['image']
                          : ImgLinks.profileImage,
                    ),
                    isTransparent: true,
                  );
                },
                child: Hero(
                  tag: "123",
                  child: CacheImageWidget(
                    width: 100,
                    height: 100,
                    isCircle: true,
                    radius: 200,
                    url:
                        (ref.watch(userDataClass).userData['image'] != null &&
                            ref
                                .watch(userDataClass)
                                .userData['image']
                                .toString()
                                .isNotEmpty)
                        ? Api.imgPath +
                              ref.watch(userDataClass).userData['image']
                        : ImgLinks.profileImage,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ref.watch(userDataClass).isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 200),
                        child: DotLoader(),
                      ),
                    )
                  : ref.watch(userDataClass).userData.isEmpty
                  ? const Center(child: Text("Failed to load user data"))
                  : Column(
                      children: [
                        ListTile(
                          title: Text(
                            ref.watch(userDataClass).userData['name'] ?? '',
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
                            ref.watch(userDataClass).userData['email'] ?? '',
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
                            ref.watch(userDataClass).userData['phone'] ?? '',
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
                            ref.watch(userDataClass).userData['address'] ?? '',
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
                            ref.watch(userDataClass).userData['aboutUs'] ??
                                'empty',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
              SizedBox(
                height: ref.watch(userDataClass).isLoading
                    ? ScreenSize.height * 0.2
                    : ScreenSize.height * 0.05,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    goto(ProfileUpdatePage());
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Edit", style: TextStyle(color: Colors.black)),
                      SizedBox(width: 10),
                      Icon(Icons.edit, color: Colors.black),
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
        child: const Icon(Icons.exit_to_app, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            animationStyle: AnimationStyle(
              curve: ElasticOutCurve(),
              // curve: ElasticInOutCurve(),
              duration: Duration(milliseconds: 1000),
            ),
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  "Are you sure you want to logout?",
                  style: TextStyle(color: Colors.grey),
                ),
                backgroundColor: Colors.black,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                  TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.watch(userDataClass).logout();
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      .animate(
                        onPlay: (controller) => controller.repeat(
                          reverse: true,
                          period: const Duration(milliseconds: 1500),
                        ),
                      )
                      .shimmer(color: Colors.red.shade200),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 4),
    );
  }
}

///////////for profileview widget page
class Profileview extends StatelessWidget {
  final String imagelink;
  const Profileview({super.key, required this.imagelink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(200, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
        ),
      ),
      body: InkWell(
        onTapUp: (v) {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Hero(
            tag: "123",
            child: CacheImageWidget(
              url: imagelink,
              isCircle: false,
              fit: BoxFit.contain,
              height: ScreenSize.height * 0.7,
              width: ScreenSize.width,
            ),
          ),
        ),
      ),
    );
  }
}
