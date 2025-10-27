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
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/imageview.dart';

import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/appColors.dart';
import '../../constants/screensizes.dart';
import '../../models/rent_in_model.dart';
import '../../services/toast.dart';
import '../../widgets/rentStepperWidget.dart';

class RentInDetailsPage extends ConsumerStatefulWidget {
  final RentInModel renting;
  const RentInDetailsPage({super.key, required this.renting});

  @override
  ConsumerState<RentInDetailsPage> createState() => _RentInDetailsPageState();
}

class _RentInDetailsPageState extends ConsumerState<RentInDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent In Details"),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),

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
                            .watch(rentInProvider)
                            .deleteOrder(
                              orderId: widget.renting.id.toString(),
                              loadingFor: "delete${widget.renting.id}",
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
                ref.watch(rentInProvider).loadingFor ==
                    "delete${widget.renting.id}"
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
        onPressed: () {},
        child: Icon(Icons.chat_outlined),
      ),
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
            const SizedBox(height: 5),

            ProRentStatusStepper(
              initialStatus: widget.renting.isRejected.toString() == '1'
                  ? "0"
                  : widget.renting.deliverd.toString() == '0'
                  ? "1"
                  : widget.renting.deliverd.toString() == '1'
                  ? "2"
                  : widget.renting.deliverd.toString() == '2'
                  ? "3"
                  : '2',
              onStatusChanged: (status) {},
              selectAble: false,
              height: 30,
              cornerRadius: 20,
            ),
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
                    debugPrint(
                      (widget.renting.dailyrate * daysCount).toString(),
                    );
                    // return;

                    ref
                        .watch(rentInProvider)
                        .updateRentnPickupTime(
                          uid: ref
                              .watch(userDataClass)
                              .userData["id"]
                              .toString(),
                          orderId: widget.renting.id.toString(),
                          loadingFor: "updateRentnPickupTime",
                          pickup_date_range: finalDateRange,
                          total_price: (widget.renting.dailyrate * daysCount)
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
                style: TextStyle(color: Colors.grey),
              ),
              subtitle:
                  Text(
                        widget.renting.userCanPickupInDateRange,
                        style: TextStyle(color: Colors.black),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        color: Colors.cyan,
                        duration: Duration(seconds: 2),
                      ),

              trailing:
                  Text(
                        "\$ ${widget.renting.totalPriceByUser}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider.builder(
              itemCount: widget.renting.productImage.length,
              itemBuilder: (context, index, realIndex) {
                final imageUrl = widget.renting.productImage[index];
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
                autoPlay: widget.renting.productImage.length > 1,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: widget.renting.productImage.length > 1,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status Row
                  // const SizedBox(height: 5),
                  Text(
                    widget.renting.productTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Description Section
                  if (widget.renting.productDesc.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(widget.renting.productDesc),
                    const SizedBox(height: 24),
                  ],

                  SizedBox(height: 20),
                  const Text(
                    "  Rates",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                    ),
                  ),
                  // Rental Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        _buildInfoRow(
                          "Daily Rate",
                          "\$${widget.renting.dailyrate ?? '0'}",
                        ),
                        _buildInfoRow(
                          "Weekly Rate",
                          "\$${widget.renting.weeklyrate ?? '0'}",
                        ),
                        _buildInfoRow(
                          "Monthly Rate",
                          "\$${widget.renting.monthlyrate ?? '0'}",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  const Text(
                    "  Calender",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                    ),
                  ),
                  // Rental Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          minTileHeight: 0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          minLeadingWidth: 50,
                          leading: Text(
                            "Order Date",
                            style: TextStyle(color: Colors.grey),
                          ),
                          title:
                              Text(
                                    "${widget.renting.userCanPickupInDateRange}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .shimmer(
                                    color: AppColors.mainColor,
                                    duration: Duration(seconds: 2),
                                  ),
                        ),
                        Divider(color: Colors.grey.shade300),

                        ListTile(
                          minTileHeight: 0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          minLeadingWidth: 50,
                          leading: Text(
                            "Availability",
                            style: TextStyle(color: Colors.grey),
                          ),
                          title:
                              Text(
                                    widget.renting.availability,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .shimmer(
                                    color: Colors.black,
                                    duration: Duration(seconds: 2),
                                  ),
                        ),

                        Divider(color: Colors.grey.shade300),
                        ListTile(
                          minTileHeight: 0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          minLeadingWidth: 50,
                          leading: Text(
                            "Listing Date",
                            style: TextStyle(color: Colors.grey),
                          ),
                          title: Text(
                            "${widget.renting.productby?.createdAt}",
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                        ),

                        // Divider(color: Colors.green.shade50),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(height: 20),
                  const Text(
                    "  Listing By",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                    ),
                  ),
                  // User Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 60,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: CacheImageWidget(
                                width: 50,
                                height: 40,
                                isCircle: true,
                                radius: 0,
                                url: widget.renting.productby!.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            widget.renting.productby?.name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            widget.renting.productby?.email ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          "Phone Number",
                          widget.renting.productby?.phone ?? '',
                        ),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          "Address",
                          widget.renting.productby?.address ?? '',
                        ),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          "About",
                          widget.renting.productby?.aboutUs ?? '',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
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
