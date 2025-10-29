import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/tostring.dart';
import 'package:rent/widgets/casheimage.dart';

import '../constants/appColors.dart';
import '../constants/screensizes.dart';
import 'imageview.dart';

class ItemContentDetailsWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final List<String>? images;
  final String? catgImg;
  final String? catgName;
  final String? dailyRate;
  final String? weeklyRate;
  final String? monthlyRate;
  final String? availability;
  final String? listingDate;
  final String? orderDate;
  final String? userImage;
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final String? userAddress;
  final String? userAbout;

  const ItemContentDetailsWidget({
    super.key,
    this.title,
    this.description,
    this.images,
    this.catgImg,
    this.catgName,
    this.dailyRate,
    this.weeklyRate,
    this.monthlyRate,
    this.availability,
    this.listingDate,
    this.orderDate,
    this.userImage,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userAddress,
    this.userAbout,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Images Carousel
          if (images != null && images!.isNotEmpty)
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider.builder(
                      itemCount: images!.length,
                      itemBuilder: (context, index, realIndex) {
                        final imageUrl = images![index];
                        return CacheImageWidget(
                          onTap: () => showImageView(context, imageUrl),
                          width: double.infinity,
                          height: ScreenSize.height * 0.3,
                          isCircle: false,
                          fit: BoxFit.cover,
                          radius: 0,
                          url: imageUrl,
                        );
                      },
                      options: CarouselOptions(
                        height: ScreenSize.height * 0.4,
                        viewportFraction: 0.68,
                        enlargeCenterPage: true,
                        autoPlay: images!.length > 1,
                        autoPlayInterval: const Duration(seconds: 2),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 800,
                        ),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: images!.length > 1,
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 0.2.seconds, duration: 0.4.seconds)
                    .slideY(begin: -0.2),
                // Positioned(
                //   // bottom: 0,
                //   // left: 0,
                //   child: Container(
                //     height: 100,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.bottomCenter,
                //         end: Alignment.topCenter,
                //         colors: [
                //           AppColors.mainColor.shade50.withOpacity(0.7),
                //           AppColors.mainColor.shade100.withOpacity(0.4),
                //           AppColors.mainColor.shade100.withOpacity(0.0),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          else
            const SizedBox.shrink(),

          const SizedBox(height: 20),

          // Title
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Description
          if (description != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: HtmlWidget(description!),
              ),
            ),

          const SizedBox(height: 25),

          // Category Section
          if (catgImg != null &&
              catgName != null &&
              catgImg!.isNotEmpty &&
              catgName!.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                tileColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                leading: CacheImageWidget(
                  onTap: () => showImageView(context, catgImg!),
                  width: 25,
                  height: 25,
                  isCircle: true,
                  radius: 5,
                  url: catgImg!,
                ),
                title: Text(catgName!),
                trailing: const Text("Category  "),
              ),
            ),

          const SizedBox(height: 15),

          // Rates Header
          dailyRate == null
              ? SizedBox.shrink()
              : const Text(
                      "Rates",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1.seconds, duration: 0.6.seconds)
                    .slideX(begin: -0.1),

          // Rental Rates Card
          dailyRate == null
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child:
                      Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                if (dailyRate != null)
                                  CupertinoListTile(
                                    title: const Text(
                                      "Daily Rate:",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    trailing: Text(
                                      "\$$dailyRate",
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                if (weeklyRate != null) ...[
                                  const Divider(),
                                  CupertinoListTile(
                                    title: const Text(
                                      "Weekly Rate:",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    trailing: Text(
                                      "\$$weeklyRate",
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                                if (monthlyRate != null) ...[
                                  const Divider(),
                                  CupertinoListTile(
                                    title: const Text(
                                      "Monthly Rate:",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    trailing: Text(
                                      "\$$monthlyRate",
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 1.2.seconds, duration: 0.8.seconds)
                          .slideY(begin: 0.1),
                ),

          const SizedBox(height: 28),

          // Calendar Header
          listingDate == null
              ? SizedBox.shrink()
              : const Text(
                      "Calendar",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1.seconds, duration: 0.6.seconds)
                    .slideX(begin: -0.1),

          // Calendar Info Card
          listingDate == null
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child:
                      Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.mainColor.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (orderDate != null) ...[
                                  ListTile(
                                    minTileHeight: 0,
                                    contentPadding: EdgeInsets.zero,
                                    trailing: const Icon(
                                      Icons.calendar_today,
                                      color: AppColors.mainColor,
                                      size: 20,
                                    ),
                                    title: const Text(
                                      "Order Date",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle:
                                        Text(
                                              orderDate!,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                            .animate(
                                              onPlay: (controller) =>
                                                  controller.repeat(),
                                            )
                                            .shimmer(
                                              color: AppColors.mainColor,
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade200,
                                    height: 20,
                                  ),
                                ],
                                if (availability != null)
                                  ListTile(
                                    minTileHeight: 0,
                                    contentPadding: EdgeInsets.zero,
                                    trailing: const Icon(
                                      Icons.access_time,
                                      color: AppColors.mainColor,
                                      size: 20,
                                    ),
                                    title: const Text(
                                      "Availability",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle:
                                        Text(
                                              availability!,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                            .animate(
                                              onPlay: (controller) =>
                                                  controller.repeat(),
                                            )
                                            .shimmer(
                                              color: Colors.black,
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                  ),
                                if (listingDate != null) ...[
                                  if (availability != null)
                                    Divider(
                                      color: Colors.grey.shade200,
                                      height: 20,
                                    ),
                                  ListTile(
                                    minTileHeight: 0,
                                    contentPadding: EdgeInsets.zero,
                                    trailing: const Icon(
                                      Icons.list_alt,
                                      color: AppColors.mainColor,
                                      size: 20,
                                    ),
                                    title: const Text(
                                      "Listing Date",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      listingDate!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 1.6.seconds, duration: 0.8.seconds)
                          .slideY(begin: 0.1),
                ),

          const SizedBox(height: 28),

          // User Section
          if (userName != null) ...[
            const Text(
                  "Listing By",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                )
                .animate()
                .fadeIn(delay: 1.seconds, duration: 0.6.seconds)
                .slideX(begin: -0.1),

            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child:
                  Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.mainColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: userImage != null
                                  ? ClipOval(
                                      child: CacheImageWidget(
                                        onTap: () =>
                                            showImageView(context, userImage!),
                                        width: 45,
                                        height: 45,
                                        isCircle: true,
                                        radius: 0,
                                        url: userImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : null,
                              title: Text(
                                userName!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: userEmail != null
                                  ? Text(
                                      userEmail!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : null,
                            ),
                            if (userPhone != null) ...[
                              Divider(color: Colors.grey.shade200, height: 24),
                              const SizedBox(height: 8),
                              _buildInfoRow("Phone Number", userPhone!),
                            ],
                            if (userAddress != null) ...[
                              Divider(color: Colors.grey.shade200, height: 20),
                              const SizedBox(height: 8),
                              _buildInfoRow("Address", userAddress!),
                            ],
                            if (userAbout != null) ...[
                              Divider(color: Colors.grey.shade200, height: 20),
                              const SizedBox(height: 8),
                              _buildInfoRow("About", userAbout!),
                            ],
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 2.seconds, duration: 0.8.seconds)
                      .slideY(begin: 0.1),
            ),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
