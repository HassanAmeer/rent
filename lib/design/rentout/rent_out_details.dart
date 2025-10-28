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
import '../../apidata/categoryapi.dart';
import '../../apidata/rent_out_api.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/appColors.dart';
import '../../constants/images.dart';
import '../../models/rent_out_model.dart';
import '../../widgets/casheimage.dart';
import '../../widgets/dotloader.dart';
import '../../widgets/imageview.dart';
import '../../widgets/item_content_details_widget.dart';
import '../../widgets/rentStepperWidget.dart';

class RentOutDetailsPage extends ConsumerStatefulWidget {
  final int index;
  RentOutDetailsPage({super.key, required this.index});

  @override
  ConsumerState<RentOutDetailsPage> createState() => _RentOutDetailsPageState();
}

class _RentOutDetailsPageState extends ConsumerState<RentOutDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final itemIndex = ref.watch(rentOutProvider).comingOrders[widget.index];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "  Rent Out Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.black,
                  title: const Text(
                    'Delete Order',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Are you sure you want to delete this?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',

                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // ✅ delete using ref
                        ref
                            .watch(rentOutProvider)
                            .deleteOrder(
                              orderId: itemIndex.id.toString(),
                              loadingFor: "delete${itemIndex.id}",
                            );
                        Navigator.pop(context);
                      },
                      child:
                          const Text(
                                'Delete',
                                style: TextStyle(color: Colors.grey),
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .shimmer(color: Colors.red.shade200),
                    ),
                  ],
                ),
              );
            },
            icon:
                ref.watch(rentOutProvider).loadingfor == "delete${itemIndex.id}"
                ? CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black,
                    child: DotLoader(showDots: 1),
                  )
                : Icon(Icons.delete),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.chat_outlined, size: 22),
      ).animate().scale(delay: 0.5.seconds, duration: 0.5.seconds),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 0, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, -2),
              blurRadius: 10,
              spreadRadius: 0,
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
              initialStatus: itemIndex.isRejected.toString() == '1'
                  ? "0"
                  : itemIndex.delivered.toString() == '0'
                  ? "1"
                  : itemIndex.delivered.toString() == '1'
                  ? "2"
                  : itemIndex.delivered.toString() == '2'
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
                      orderId: itemIndex.id.toString(),
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
            ).animate().fadeIn(delay: 0.3.seconds, duration: 0.8.seconds),
            Divider(height: 2),
            CupertinoListTile(
              // minVerticalPadding: 0,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              title: Text(
                "Pickup Date Range From User:",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle:
                  Text(
                        itemIndex.userCanPickupInDateRange,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        color: AppColors.mainColor,
                        duration: Duration(seconds: 2),
                      ),

              trailing:
                  Text(
                        "\$ ${itemIndex.totalPriceByUser}",
                        style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        color: Colors.black,
                        duration: Duration(seconds: 2),
                      ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ).animate().fade(duration: 1.seconds).slideY(begin: 1),
      body: ItemContentDetailsWidget(
        images: itemIndex.productImages,
        title: itemIndex.productTitle,
        description: itemIndex.productDesc,
        catgName:
            "${itemIndex.categoryId != null
                ? ref.watch(categoryProvider).categories.where((e) => e.id == itemIndex.categoryId).isNotEmpty
                      ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == itemIndex.categoryId).name
                      : null
                : null}",
        catgImg:
            "${itemIndex.categoryId != null
                ? ref.watch(categoryProvider).categories.where((e) => e.id == itemIndex.categoryId).isNotEmpty
                      ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == itemIndex.categoryId).image
                      : null
                : null}",
        dailyRate: itemIndex.dailyRate.toString(),
        weeklyRate: itemIndex.weeklyRate.toString(),
        monthlyRate: itemIndex.monthlyRate.toString(),
        availability: itemIndex.availability ?? '',
        listingDate: itemIndex.createdAt.toString(),
        // orderDate: orderDate,
        userImage: itemIndex.orderByUser?.image,
        userName: itemIndex.orderByUser?.name,
        userEmail: itemIndex.orderByUser?.email,
        userPhone: itemIndex.orderByUser?.phone,
        userAddress: itemIndex.orderByUser?.address,
        userAbout: itemIndex.orderByUser?.aboutUs,
      ),
    );
  }
}
