import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/toast.dart';
// import 'package:rent/apidata/bookingapi.dart';
// import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/design/booking/booking_details.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/widgets/btmnavbar.dart';
// import 'package:rent/design/myrentals/itemsrent.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../apidata/bookingapi.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../widgets/searchfield.dart';
import '../../models/booking_model.dart';

class MyBookingPage extends ConsumerStatefulWidget {
  const MyBookingPage({super.key});

  @override
  ConsumerState<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends ConsumerState<MyBookingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref
          .watch(bookingDataProvider)
          .fetchComingOrders(
            uid: ref.watch(userDataClass).userData["id"].toString(),
            search: "",
            loadingfor: "3421",
          );
      super.initState();
    });
  }

  var searchfieldcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Bookings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 2),
      body: SingleChildScrollView(
        controller: ScrollController(),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Search bar just below AppBar (with grey background)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchFeildWidget(
                searchFieldController: searchfieldcontroller,
                hint: "Search How to & More",
                onSearchIconTap: () {
                  if (searchfieldcontroller.text.isEmpty) {
                    toast("Write Someting");
                    return;
                  }
                  ref
                      .watch(bookingDataProvider)
                      .fetchComingOrders(
                        uid: ref.watch(userDataClass).userData["id"].toString(),
                        search: searchfieldcontroller.text,
                        loadingfor: "3421",
                      );
                },
              ),
            ),

            ref.watch(bookingDataProvider).loadingfor == "3421"
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 250),
                      child: DotLoader(),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    itemCount: ref
                        .watch(bookingDataProvider)
                        .comingOrders
                        .length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Mobile 2 columns
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.85,
                        ),
                    itemBuilder: (context, index) => _bookingCard(
                      context,
                      ref.watch(bookingDataProvider).comingOrders[index],
                    ),
                  ),
          ],
        ),
      ),

      // Floating Action Button for Add New Booking
      // bottomNavigationBar: BottomNavBarWidget(currentIndex: 2),
    );
  }

  Widget _bookingCard(BuildContext context, BookingModel booking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.14),
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              goto(Bookindetails(data: booking));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: CacheImageWidget(
                          isCircle: false,
                          fit: BoxFit.cover,
                          width: ScreenSize.width * 0.45,
                          // width: double.infinity,
                          height: ScreenSize.height * 0.2,
                          url: booking.productImages.isNotEmpty
                              ? booking.productImages[0]
                              : ImgLinks.product,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // title text inside fixed width
                  Text(
                    booking.displayTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  // const SizedBox(height: 1),
                  // orderby name inside fixed width
                  Text(
                    booking.orderByUser?.displayName ?? 'Unknown User',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ),
          // Right-top Status Label
          Positioned(
            right: 8,
            top: 8,
            child: _statusLabel(booking.delivered.toString()),
          ),
        ],
      ),
    );
  }

  Widget _iconCircleButton(
    IconData icon,
    Color iconColor,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.black,
        child: Icon(icon, color: iconColor, size: 16.5),
      ),
    );
  }

  Widget _statusLabel(String? status) {
    Color bgColor = Colors.orange;
    String label = "Delivered";

    if (status.toString() == "0") {
      bgColor = Colors.orange.withOpacity(0.5);
      label = "Not delivered";
    } else {
      bgColor = Colors.green.withOpacity(0.7);
      label = "Delivered";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }
}
