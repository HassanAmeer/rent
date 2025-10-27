import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:rent/apidata/bookingapi.dart';
// import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/design/rentout/rent_out_details.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/widgets/btmnavbar.dart';
// import 'package:rent/design/myrentals/itemsrent.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import '../../apidata/rent_out_api.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/appColors.dart';
import '../../services/goto.dart';
import '../../services/toast.dart';
import '../../widgets/searchfield.dart';
import '../../models/rent_out_model.dart';

class RentOutPage extends ConsumerStatefulWidget {
  final bool refresh;
  const RentOutPage({super.key, this.refresh = false});

  @override
  ConsumerState<RentOutPage> createState() => _RentOutPageState();
}

class _RentOutPageState extends ConsumerState<RentOutPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref
          .watch(rentOutProvider)
          .fetchComingOrders(
            uid: ref.watch(userDataClass).userData["id"].toString(),
            search: "",
            refresh: widget.refresh,
            loadingfor: widget.refresh ? "refresh" : "fetchComingOrders",
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
        automaticallyImplyLeading: true,
        title: const Text(
          "  Rent Out",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
              .watch(rentOutProvider)
              .fetchComingOrders(
                uid: ref.watch(userDataClass).userData["id"].toString(),
                search: "",
                refresh: true,
                loadingfor: "refresh",
              );
        },
        child: SingleChildScrollView(
          controller: ScrollController(),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ref.watch(rentOutProvider).loadingfor == "refresh"
                  ? QuickTikTokLoader(
                      progressColor: Colors.black,
                      backgroundColor: Colors.grey,
                    )
                  : SizedBox.shrink(),

              // Search bar just below AppBar (with grey background)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchFeildWidget(
                  searchFieldController: searchfieldcontroller,
                  hint: "Search How to & More",
                  onSearchIconTap: () {
                    // if (searchfieldcontroller.text.isEmpty) {
                    //   toast("Write Someting");
                    //   return;
                    // }
                    ref
                        .watch(rentOutProvider)
                        .fetchComingOrders(
                          uid: ref
                              .watch(userDataClass)
                              .userData["id"]
                              .toString(),
                          refresh: true,
                          search: searchfieldcontroller.text,
                          loadingfor: "refresh",
                        );
                  },
                ),
              ),

              ref.watch(rentOutProvider).loadingfor == "fetchComingOrders"
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
                      itemCount: ref.watch(rentOutProvider).comingOrders.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Mobile 2 columns
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.85,
                          ),
                      itemBuilder: (context, index) => _bookingCard(
                        context,
                        ref.watch(rentOutProvider).comingOrders[index],
                        index,
                      ),
                    ),
            ],
          ),
        ),
      ),
      // Floating Action Button for Add New Booking
      // bottomNavigationBar: BottomNavBarWidget(currentIndex: 2),
    );
  }

  Widget _bookingCard(BuildContext context, BookingModel booking, int index) {
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
              goto(RentOutDetailsPage(index: index));
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
          Positioned(
            left: 8,
            top: 0,
            child: IconButton(
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
                              .watch(rentOutProvider)
                              .deleteOrder(
                                orderId: booking.id.toString(),
                                loadingFor: "delete${booking.id}",
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
                  ref.watch(rentOutProvider).loadingfor == "delete${booking.id}"
                  ? CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.black,
                      child: DotLoader(showDots: 1),
                    )
                  : Icon(Icons.delete),
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
      label = "Pending";
    } else if (status.toString() == "1") {
      bgColor = AppColors.mainColor.withOpacity(0.7);
      label = "Rented";
    } else {
      bgColor = Colors.green.withOpacity(0.7);
      label = "Closed";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
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
