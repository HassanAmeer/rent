import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:rent/apidata/bookingapi.dart';
// import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/design/booking/bookingdetails.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/scrensizes.dart';
// import 'package:rent/design/myrentals/itemsrent.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../apidata/bookingapi.dart';
import '../../apidata/user.dart';

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
            uid: ref.watch(userDataClass).userdata["id"].toString(),
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          "My Bookings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search bar just below AppBar (with grey background)
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: searchfieldcontroller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: InkWell(
                  onTap: () {
                    ref
                        .watch(bookingDataProvider)
                        .fetchComingOrders(
                          uid: ref
                              .watch(userDataClass)
                              .userdata["id"]
                              .toString(),
                          search: searchfieldcontroller.text,
                          loadingfor: "3421",
                        );
                  },
                  child: const Icon(Icons.search, color: Colors.black54),
                ),
                hintText: "Search How to & More",
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
          ref.watch(bookingDataProvider).loadingfor == "3421"
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 250),
                    child: DotLoader(),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: ref
                        .watch(bookingDataProvider)
                        .comingOrders
                        .length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Mobile 2 columns
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          childAspectRatio: 0.85,
                        ),
                    itemBuilder: (context, index) => _bookingCard(
                      context,
                      ref.watch(bookingDataProvider).comingOrders[index],
                    ),
                  ),
                ),
        ],
      ),

      // Floating Action Button for Add New Booking
      // bottomNavigationBar: BottomNavBarWidget(currentIndex: 2),
    );
  }

  Widget _bookingCard(BuildContext context, Map<String, dynamic> booking) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left-side icons column
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 6),
              ),

              // Main content (image and texts, centered)
              InkWell(
                onTap: () {
                  goto(Bookindetails(data: booking));
                },
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 86,
                            width: 115,
                            color: Colors.grey.shade200,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: CacheImageWidget(
                                isCircle: false,
                                url:
                                    Config.imgUrl +
                                    (jsonDecode(booking['productImage'])[0] ??
                                        ImgLinks.product),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // title text inside fixed width
                        SizedBox(
                          width: 110, // same as image width for alignment
                          child: Text(
                            booking["productTitle"].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // orderby name inside fixed width
                        SizedBox(
                          width: 110,
                          child: Text(
                            ref
                                .watch(bookingDataProvider)
                                .comingOrders[0]["orderby"]['name']
                                .toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Right-top Status Label
          Positioned(
            right: 8,
            top: 8,
            child: _statusLabel(booking["deliverd"].toString()),
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
