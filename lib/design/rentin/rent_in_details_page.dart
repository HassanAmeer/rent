import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rent/apidata/rent_in_api.dart';
// import 'package:rent/apidata/myrentalapi.dart' show rentalDataProvider;
import 'package:rent/constants/images.dart';
import 'package:rent/design/message/chat.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/imageview.dart';

import '../../apidata/categoryapi.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/appColors.dart';
import '../../constants/screensizes.dart';
import '../../models/chatedUsersModel.dart';
import '../../models/rent_in_model.dart';
import '../../services/goto.dart';
import '../../services/toast.dart';
import '../../widgets/item_content_details_widget.dart';
import '../../widgets/rentStepperWidget.dart';

class RentInDetailsPage extends ConsumerStatefulWidget {
  final int index;
  const RentInDetailsPage({super.key, required this.index});

  @override
  ConsumerState<RentInDetailsPage> createState() => _RentInDetailsPageState();
}

class _RentInDetailsPageState extends ConsumerState<RentInDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final itemIndex = ref.watch(rentInProvider).rentInListData[widget.index];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, AppColors.mainColor.shade100],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: const Text(
        //     "Rent In Details",
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 20,
        //     ),
        //   ),
        //   elevation: 0,
        //   backgroundColor: AppColors.mainColor,
        //   iconTheme: const IconThemeData(color: Colors.white),
        //   actions: [
        //     const Text(
        //       "Rent In Details",
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 20,
        //       ),
        //     ),
        //     IconButton(
        //       onPressed: () async {
        //         showDialog(
        //           context: context,
        //           builder: (context) => AlertDialog(
        //             backgroundColor: Colors.black,
        //             title: const Text(
        //               'Delete Order',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //             content: const Text(
        //               'Are you sure you want to delete this?',
        //               style: TextStyle(color: Colors.grey),
        //             ),
        //             actions: [
        //               TextButton(
        //                 onPressed: () => Navigator.pop(context),
        //                 child: const Text(
        //                   'Cancel',

        //                   style: TextStyle(color: Colors.grey),
        //                 ),
        //               ),
        //               TextButton(
        //                 onPressed: () {
        //                   // ✅ delete using ref
        //                   ref
        //                       .watch(rentInProvider)
        //                       .deleteOrder(
        //                         orderId: itemIndex.id.toString(),
        //                         loadingFor: "delete${itemIndex.id}",
        //                       );
        //                   Navigator.pop(context);
        //                 },
        //                 child:
        //                     const Text(
        //                           'Delete',
        //                           style: TextStyle(color: Colors.grey),
        //                         )
        //                         .animate(
        //                           onPlay: (controller) =>
        //                               controller.repeat(reverse: true),
        //                         )
        //                         .shimmer(color: Colors.red.shade200),
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //       icon:
        //           ref.watch(rentInProvider).loadingFor ==
        //               "delete${itemIndex.id}"
        //           ? CircleAvatar(
        //               radius: 10,
        //               backgroundColor: Colors.black,
        //               child: DotLoader(showDots: 1),
        //             )
        //           : Icon(Icons.delete),
        //     ),
        //   ],
        // ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                if (itemIndex.productby == null) {
                  toast("User not Available From Long Time!");
                  return;
                }
                goto(
                  Chats(
                    msgdata: ChatedUsersModel(
                      id: 1,
                      sid: int.tryParse(
                        ref.watch(userDataClass).userData["id"].toString(),
                      ),
                      rid: int.tryParse(itemIndex.productby!.id.toString()),
                      msg: "",
                      fromuid: ChatUser(
                        id: int.tryParse(
                          ref.watch(userDataClass).userData["id"].toString(),
                        ),
                        image: ref
                            .watch(userDataClass)
                            .userData["image"]
                            .toString(),
                        name: ref
                            .watch(userDataClass)
                            .userData["name"]
                            .toString(),
                      ),
                      touid: ChatUser(
                        id: int.tryParse(itemIndex.productby!.id.toString()),
                        image: itemIndex.productby!.image.toString(),
                        name: itemIndex.productby!.name.toString(),
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.chat_outlined,
                size: 22,
                color: Colors.white,
              ),
            ).animate().scale(
              delay: Duration(milliseconds: 300),
              duration: Duration(milliseconds: 500),
            ),
            SizedBox(height: 15),
            FloatingActionButton.small(
              onPressed: () {
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
                              .watch(rentInProvider)
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
              child:
                  ref.watch(rentInProvider).loadingFor ==
                      "delete${itemIndex.id}"
                  ? CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: DotLoader(showDots: 1),
                    )
                  : Icon(Icons.delete),
            ).animate().scale(delay: 0.5.seconds, duration: 0.5.seconds),
          ],
        ),
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
              const SizedBox(height: 5),

              ProRentStatusStepper(
                initialStatus: itemIndex.isRejected.toString() == '1'
                    ? "0"
                    : itemIndex.deliverd.toString() == '0'
                    ? "1"
                    : itemIndex.deliverd.toString() == '1'
                    ? "2"
                    : itemIndex.deliverd.toString() == '2'
                    ? "3"
                    : '2',
                onStatusChanged: (status) {},
                selectAble: false,
                height: 30,
                cornerRadius: 20,
              ).animate().fadeIn(delay: 0.3.seconds, duration: 0.8.seconds),
              Divider(height: 2),
              CupertinoListTile(
                // minVerticalPadding: 0,
                leading: IconButton(
                  onPressed: () async {
                    try {
                      List<DateTime?> dates = [];
                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                          calendarType: CalendarDatePicker2Type.range,
                        ),
                        dialogSize: const Size(325, 400),
                        value: dates,
                        borderRadius: BorderRadius.circular(15),
                      );

                      if (results!.isEmpty) {
                        toast("Please Pickup date range");
                      }

                      // print(results.toString());
                      var startDate = results.first; // DateTime
                      var endDate = results.last; // DateTime

                      // Formatter
                      var formatter = DateFormat("d MMMM yyyy");

                      // Convert to string
                      var finalDateRange =
                          "${formatter.format(startDate!)} to ${formatter.format(endDate!)}";
                      // print(finalDateRange.toString());
                      var daysCount = endDate.difference(startDate).inDays + 1;
                      ////
                      debugPrint((itemIndex.dailyrate * daysCount).toString());
                      // return;

                      ref
                          .watch(rentInProvider)
                          .updateRentnPickupTime(
                            uid: ref
                                .watch(userDataClass)
                                .userData["id"]
                                .toString(),
                            orderId: itemIndex.id.toString(),
                            loadingFor: "updateRentnPickupTime",
                            pickup_date_range: finalDateRange,
                            total_price:
                                (int.tryParse(itemIndex.dailyrate ?? '0')! *
                                        daysCount)
                                    .toString(),
                          );
                    } catch (e) {
                      debugPrint("error $e");
                      toast("Try Later! $e");
                    }
                  },
                  icon:
                      ref.watch(rentInProvider).loadingFor ==
                          "updateRentnPickupTime"
                      ? DotLoader(showDots: 1, size: 20, spacing: 0)
                      : Icon(Icons.edit_outlined),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                title: Text(
                  "My Pickup Date:",
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
        body: SafeArea(
          child: SingleChildScrollView(
            controller: ScrollController(),
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: const Text(
                //     "  Rent In Details",
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //     ),
                //   ),
                // ),
                Stack(
                  children: [
                    ItemContentDetailsWidget(
                      images: itemIndex.productImage,
                      title: itemIndex.productTitle,
                      description: itemIndex.productDesc,
                      catgName:
                          "${itemIndex.productby != null
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
                      dailyRate: itemIndex.dailyrate.toString(),
                      weeklyRate: itemIndex.weeklyrate.toString(),
                      monthlyRate: itemIndex.monthlyrate.toString(),
                      availability: itemIndex.availability ?? '',
                      listingDate: itemIndex.createdAt.toString(),
                      // orderDate: orderDate,
                      userImage: itemIndex.productby?.image,
                      userName: itemIndex.productby?.name,
                      userEmail: itemIndex.productby?.email,
                      userPhone: itemIndex.productby?.phone,
                      userAddress: itemIndex.productby?.address,
                      userAbout: itemIndex.productby?.aboutUs,
                    ),

                    Positioned(
                      left: 10,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: const Offset(0, 0),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  // Helper method to build info card
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
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
