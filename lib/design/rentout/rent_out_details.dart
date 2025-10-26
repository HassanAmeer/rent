import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide StepValue;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/services/toast.dart';
import '../../apidata/rent_out_api.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/appColors.dart';
import '../../constants/images.dart';
import '../../models/rent_out_model.dart';
import '../../widgets/casheimage.dart';
import '../../widgets/imageview.dart';
import '../../widgets/rentStepperWidget.dart';

class RentOutDetailsPage extends ConsumerStatefulWidget {
  BookingModel data;
  RentOutDetailsPage({super.key, required this.data});

  @override
  ConsumerState<RentOutDetailsPage> createState() => _RentOutDetailsPageState();
}

class _RentOutDetailsPageState extends ConsumerState<RentOutDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("  Rent Out Details")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(Icons.chat_outlined, size: 22, color: Colors.white),
      ).animate().flipH().shimmer(duration: 2.seconds),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 0, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(1, 1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ref.watch(rentOutProvider).loadingfor == "status"
                ? QuickTikTokLoader(
                    progressColor: Colors.black,
                    backgroundColor: Colors.grey,
                  )
                : SizedBox.shrink(),
            const SizedBox(height: 5),

            ProRentStatusStepper(
              initialStatus: widget.data.isRejected.toString() == '1'
                  ? "0"
                  : widget.data.delivered.toString() == '0'
                  ? "1"
                  : widget.data.delivered.toString() == '1'
                  ? "2"
                  : widget.data.delivered.toString() == '2'
                  ? "3"
                  : '2',
              onStatusChanged: (status) {
                // print("Status → $status");
                ref
                    .watch(rentOutProvider)
                    .updateOrderStatus(
                      userId: ref
                          .watch(userDataClass)
                          .userData["id"]
                          .toString(),
                      orderId: widget.data.id.toString(),
                      statusId: status == "0"
                          ? '3'
                          : status == "1"
                          ? '0'
                          : status == "2"
                          ? '1'
                          : status == "3"
                          ? '2'
                          : '0',
                      loadingFor: 'status',
                    );
              },

              height: 30,
              cornerRadius: 20,
            ),
            Divider(height: 2),
            CupertinoListTile(
              // minVerticalPadding: 0,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              title: Text(
                "Pickup Date Range From User:",
                style: TextStyle(color: Colors.grey),
              ),
              subtitle:
                  Text(
                        widget.data.userCanPickupInDateRange,
                        style: TextStyle(color: Colors.black),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        color: AppColors.mainColor,
                        duration: Duration(seconds: 2),
                      ),

              trailing:
                  Text(
                        "\$ ${widget.data.totalPriceByUser}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        color: AppColors.mainColor,
                        duration: Duration(seconds: 2),
                      ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ).animate().fade(duration: 1.seconds).slideY(begin: 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                    itemCount: widget.data.productImages.length,
                    itemBuilder: (context, index, realIndex) {
                      final imageUrl = widget.data.productImages[index];
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
                      autoPlay: widget.data.productImages.length > 1,
                      autoPlayInterval: const Duration(seconds: 2),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll:
                          widget.data.productImages.length > 1,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                  .animate()
                  .fade(duration: 200.milliseconds)
                  .scale(begin: Offset(0.5, 0.5)),

              const SizedBox(height: 10),

              Text(
                widget.data.productTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                widget.data.productDesc ?? "",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 8),
              SizedBox(height: 5),
              ListTile(
                title: Text("Rates", style: TextStyle(color: Colors.grey)),
                minVerticalPadding: 0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    CupertinoListTile(
                      title: Text(
                        "daily rate:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Text("\$ ${widget.data.dailyRate}"),
                    ),
                    CupertinoListTile(
                      title: Text(
                        "weekly rate:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Text("\$ ${widget.data.weeklyRate}"),
                    ),
                    CupertinoListTile(
                      title: Text(
                        "monthly rate:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Text("\$ ${widget.data.monthlyRate}"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Calender", style: TextStyle(color: Colors.grey)),
                minVerticalPadding: 0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Availability Days:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      subtitle: Text(
                        widget.data.availability,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Divider(),
                    // ListTile(
                    //   title: Text(
                    //     "Pickup Date Range From User:",
                    //     style: TextStyle(color: Colors.grey),
                    //   ),
                    //   subtitle:
                    //       Text(
                    //             widget.data.userCanPickupInDateRange,
                    //             style: TextStyle(color: Colors.black),
                    //           )
                    //           .animate(
                    //             onPlay: (controller) => controller.repeat(),
                    //           )
                    //           .shimmer(
                    //             color: Colors.red,
                    //             duration: Duration(seconds: 2),
                    //           ),
                    // ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "Order Date:",
                        style: TextStyle(color: Colors.cyan),
                      ),
                      subtitle: Text(
                        "${widget.data.createdAt}",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text("Order From User")
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                          color: Colors.cyan,
                          duration: Duration(seconds: 2),
                        ),
                  ),
                ],
              ),
              SizedBox(height: 5),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CacheImageWidget(
                        width: 50,
                        height: 50,
                        isCircle: true,
                        radius: 200,
                        url: widget.data.orderByUser!.fullImageUrl,
                      ),
                      title: Text(widget.data.orderByUser!.name),
                      subtitle: Text(widget.data.orderByUser!.email),
                    ),
                    Divider(),
                    CupertinoListTile(
                      title: Text(
                        "Phone Number: ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Text("${widget.data.orderByUser?.phone}"),
                    ),
                    Divider(),
                    CupertinoListTile(
                      title: Text(
                        "Address: ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Text("${widget.data.orderByUser?.address}"),
                    ),
                    Divider(),
                    CupertinoListTile(
                      title: Text(
                        "About: ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Text("${widget.data.orderByUser?.aboutUs}"),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              SizedBox(height: 70),
              //
            ],
          ),
        ),
      ),
    );
  }

  // Container statuswidget() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: _getStatusColor(widget.data.delivered.toString()),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(
  //           _getStatusIcon(widget.data.delivered.toString()),
  //           color: Colors.white,
  //           size: 16,
  //         ),
  //         const SizedBox(width: 6),
  //         Text(
  //           _getStatusText(widget.data.delivered.toString()),
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.w600,
  //             fontSize: 12,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Helper method to get status color
  // Color _getStatusColor(String? status) {
  //   return status == "1" ? Colors.green : Colors.orange;
  // }

  // // Helper method to get status icon
  // IconData _getStatusIcon(String? status) {
  //   return status == "1" ? Icons.check_circle : Icons.history;
  // }

  // // Helper method to get status text
  // String _getStatusText(String? status) {
  //   return status == "1" ? "Delivered" : "Not Delivered";
  // }

  // Helper method to format date
  String _formatDate(dynamic date) {
    if (date == null) return 'Not specified';
    try {
      DateTime parsedDate = DateTime.parse(date.toString());
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return date.toString();
    }
  }

  // Helper method to build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
