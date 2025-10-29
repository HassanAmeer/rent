import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/tostring.dart';
import 'package:rent/widgets/casheimage.dart';
// import 'package:rent/widgets/cacheimage.dart';

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
  // final String? userCanPickupInDateRange;
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
    // this.userCanPickupInDateRange,
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
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          images == null || images!.isEmpty
              ? SizedBox.shrink()
              : CarouselSlider.builder(
                      itemCount: images!.length,
                      itemBuilder: (context, index, realIndex) {
                        final imageUrl = images![index];
                        return CacheImageWidget(
                          onTap: () {
                            showImageView(context, imageUrl);
                          },
                          width: double.infinity,
                          height: ScreenSize.height * 0.3,
                          isCircle: false,
                          fit: BoxFit.contain,
                          radius: 0,
                          url: imageUrl,
                        );
                      },
                      options: CarouselOptions(
                        height: ScreenSize.height * 0.35,
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

          const SizedBox(height: 20),

          title == null
              ? SizedBox.shrink()
              : Padding(
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
          description == null
              ? SizedBox.shrink()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: HtmlWidget(description!),
                  ),
                ),
          const SizedBox(height: 25),

          catgImg!.toString().toNullString().isEmpty ||
                  catgName!.toString().toNullString().isEmpty
              ? SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white24,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    tileColor: Colors.grey.shade200,
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    leading: catgImg == null || catgName == null
                        ? SizedBox.shrink()
                        : CacheImageWidget(
                            onTap: () {
                              showImageView(context, catgImg!);
                            },
                            width: 25,
                            height: 25,
                            isCircle: true,
                            radius: 5,
                            url: catgImg!,
                            // "${listingData.categoryId != null
                            //     ? ref.watch(categoryProvider).categories.where((e) => e.id == listingData.categoryId).isNotEmpty
                            //           ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == listingData.categoryId).image
                            //           : null
                            //     : null}",
                          ),
                    title: catgName == null
                        ? SizedBox.shrink()
                        : Text(catgName!),
                    trailing: Text("Category  "),
                  ),
                ),
          SizedBox(height: 15),
          ListTile(
            title:
                const Text(
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
          ),
          // Rental Information Card
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child:
                Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          dailyRate == null
                              ? SizedBox.shrink()
                              : CupertinoListTile(
                                  title: Text(
                                    "Daily Rate:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Text(
                                    "\$$dailyRate",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                          weeklyRate == null ? SizedBox.shrink() : Divider(),
                          weeklyRate == null
                              ? SizedBox.shrink()
                              : CupertinoListTile(
                                  title: Text(
                                    "Weekly Rate:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Text(
                                    "\$$weeklyRate",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                          monthlyRate == null ? SizedBox.shrink() : Divider(),
                          monthlyRate == null
                              ? SizedBox.shrink()
                              : CupertinoListTile(
                                  title: Text(
                                    "Monthly Rate:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Text(
                                    "\$$monthlyRate",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1.2.seconds, duration: 0.8.seconds)
                    .slideY(begin: 0.1),
          ),

          SizedBox(height: 28),

          ListTile(
            title:
                const Text(
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
          ),
          // Calendar Information Card
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child:
                Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
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
                          orderDate == null
                              ? SizedBox.shrink()
                              : ListTile(
                                  minTileHeight: 0,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  trailing: Icon(
                                    Icons.calendar_today,
                                    color: AppColors.mainColor,
                                    size: 20,
                                  ),
                                  title: Text(
                                    "Order Date",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle:
                                      Text(
                                            "${orderDate}",
                                            style: TextStyle(
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
                                            duration: Duration(seconds: 2),
                                          ),
                                ),
                          orderDate == null
                              ? SizedBox.shrink()
                              : Divider(
                                  color: Colors.grey.shade200,
                                  height: 20,
                                ),

                          availability == null
                              ? SizedBox.shrink()
                              : ListTile(
                                  minTileHeight: 0,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  trailing: Icon(
                                    Icons.access_time,
                                    color: AppColors.mainColor,
                                    size: 20,
                                  ),
                                  title: Text(
                                    "Availability",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle:
                                      Text(
                                            availability!,
                                            style: TextStyle(
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
                                            duration: Duration(seconds: 2),
                                          ),
                                ),

                          listingDate == null
                              ? SizedBox.shrink()
                              : Divider(
                                  color: Colors.grey.shade200,
                                  height: 20,
                                ),
                          listingDate == null
                              ? SizedBox.shrink()
                              : ListTile(
                                  minTileHeight: 0,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  trailing: Icon(
                                    Icons.list_alt,
                                    color: AppColors.mainColor,
                                    size: 20,
                                  ),
                                  title: Text(
                                    "Listing Date",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "$listingDate",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                          // Divider(color: Colors.green.shade50),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1.6.seconds, duration: 0.8.seconds)
                    .slideY(begin: 0.1),
          ),

          const SizedBox(height: 28),

          SizedBox(height: 24),
          userName == null
              ? SizedBox.shrink()
              : ListTile(
                  title:
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
                ),
          // User Information Card
          userName == null
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child:
                      Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
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
                                  leading: userImage == null
                                      ? SizedBox.shrink()
                                      : ClipOval(
                                          child: CacheImageWidget(
                                            onTap: () {
                                              showImageView(
                                                context,
                                                userImage!,
                                              );
                                            },
                                            width: 45,
                                            height: 45,
                                            isCircle: true,
                                            radius: 0,
                                            url: userImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  title: userName == null
                                      ? SizedBox.shrink()
                                      : Text(
                                          userName!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                  subtitle: userEmail == null
                                      ? SizedBox.shrink()
                                      : Text(
                                          userEmail!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                                userPhone == null
                                    ? SizedBox.shrink()
                                    : Divider(
                                        color: Colors.grey.shade200,
                                        height: 24,
                                      ),
                                userPhone == null
                                    ? SizedBox.shrink()
                                    : const SizedBox(height: 8),
                                userPhone == null
                                    ? SizedBox.shrink()
                                    : _buildInfoRow("Phone Number", userPhone!),
                                userAddress == null
                                    ? SizedBox.shrink()
                                    : Divider(
                                        color: Colors.grey.shade200,
                                        height: 20,
                                      ),
                                userAddress == null
                                    ? SizedBox.shrink()
                                    : const SizedBox(height: 8),
                                userAddress == null
                                    ? SizedBox.shrink()
                                    : _buildInfoRow("Address", userAddress!),
                                userAbout == null
                                    ? SizedBox.shrink()
                                    : Divider(
                                        color: Colors.grey.shade200,
                                        height: 20,
                                      ),
                                userAbout == null
                                    ? SizedBox.shrink()
                                    : const SizedBox(height: 8),
                                userAbout == null
                                    ? SizedBox.shrink()
                                    : _buildInfoRow("About", userAbout!),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 2.seconds, duration: 0.8.seconds)
                          .slideY(begin: 0.1),
                ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Helper method to build info row
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
