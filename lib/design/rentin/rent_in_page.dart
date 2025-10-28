import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
// import 'package:rent/apidata/myrentalapi.dart' show rentInProvider;
// import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/design/all%20items/allitems.dart';
// import 'package:rent/design/myrentals/itemsrent.dart';
import 'package:rent/design/rentin/rent_in_details_page.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../apidata/rent_in_api.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/screensizes.dart';
import '../../models/rent_in_model.dart';
import '../../widgets/btmnavbar.dart';
import '../../widgets/delete_alert_box.dart';
import '../../widgets/listings_widgets/items_box_widget.dart';

class RentInPage extends ConsumerStatefulWidget {
  final bool refresh;
  const RentInPage({super.key, this.refresh = false});

  @override
  ConsumerState<RentInPage> createState() => _RentInPageState();
}

class _RentInPageState extends ConsumerState<RentInPage> {
  var searchfeildcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(userDataClass).userId;
      ref
          .read(rentInProvider)
          .fetchRentIn(
            userId: userId,
            loadingFor: widget.refresh ? "refresh" : "fetchRentIn",
            search: "",
            refresh: widget.refresh,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final rentalData = ref.watch(rentInProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const Text(
          "  Rent In",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 2),

      body: Column(
        children: [
          rentalData.loadingFor == "refresh"
              ? Container(
                  height: 60,
                  child: QuickTikTokLoader(
                    progressColor: AppColors.mainColor,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ).animate().fadeIn(duration: 0.3.seconds)
              : SizedBox.shrink(),

          // Search bar just below AppBar (with enhanced styling)
          Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchfeildcontroller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          final userId = ref.read(userDataClass).userId;
                          ref
                              .watch(rentInProvider)
                              .fetchRentIn(
                                userId: userId,
                                search: searchfeildcontroller.text,
                              );
                        },
                        icon: Icon(Icons.search, color: AppColors.mainColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search rentals & more...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 0.3.seconds, duration: 0.8.seconds)
              .slideY(begin: -0.1),

          // Rentals content with loading and empty states
          Expanded(
            child: rentalData.loadingFor == "fetchRentIn"
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DotLoader(),
                          SizedBox(height: 16),
                          Text(
                            "Loading rentals...",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 0.5.seconds).scale()
                : rentalData.rentInListData.isEmpty
                ? Center(
                        child: Container(
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.mainColor.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 80,
                                color: AppColors.mainColor,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No Rentals Found",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Your rental items will appear here",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 0.5.seconds, duration: 0.8.seconds)
                      .scale()
                : RefreshIndicator(
                    onRefresh: () async {
                      final userId = ref.read(userDataClass).userId;
                      await ref
                          .read(rentInProvider)
                          .fetchRentIn(
                            userId: userId,
                            loadingFor: "refresh",
                            search: "",
                            refresh: true,
                          );
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: rentalData.rentInListData.length,

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            ScreenSize.isLandscape || ScreenSize.isTablet
                            ? 3
                            : 2,
                        mainAxisSpacing:
                            ScreenSize.isLandscape || ScreenSize.isTablet
                            ? 20
                            : 15,
                        crossAxisSpacing:
                            ScreenSize.isLandscape || ScreenSize.isTablet
                            ? 20
                            : 15,
                        childAspectRatio: 0.95,
                      ),

                      itemBuilder: (context, index) {
                        var item = rentalData.rentInListData[index];
                        return ListingBox(
                              id: item.id.toString(),
                              title: item.productTitle,
                              showStatusLabel: true,
                              statusLabelType: item.deliverd.toString(),
                              showDelete: true,
                              isDeleteLoading:
                                  ref.watch(rentInProvider).loadingFor ==
                                  "delete${item.id}",
                              onDeleteTap: () {
                                alertBoxDelete(
                                  context,
                                  onDeleteTap: () {
                                    ref
                                        .watch(rentInProvider)
                                        .deleteOrder(
                                          orderId: item.id.toString(),
                                          loadingFor: "delete${item.id}",
                                        );
                                  },
                                );
                              },
                              imageUrl: item.productImage.first,
                              onTap: () =>
                                  goto(RentInDetailsPage(index: index)),
                            )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: index * 100),
                              duration: 0.2.seconds,
                            )
                            .slideY(begin: 0.2);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goto(AllItemsPage()); // Add new rental logic here
        },
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ).animate().scale(delay: 0.5.seconds, duration: 0.5.seconds),
    );
  }

  Widget _buildRentalItem(BuildContext context, RentInModel rental, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
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
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              goto(RentInDetailsPage(index: index));
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: AppColors.mainColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: CacheImageWidget(
                        isCircle: false,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        url: rental.productImage.first,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    rental.productTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rental.productby?.name ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.mainColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Delete Order',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        'Are you sure you want to delete this?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // ✅ delete using ref
                            ref
                                .watch(rentInProvider)
                                .deleteOrder(
                                  orderId: rental.id.toString(),
                                  loadingFor: "delete+${rental.id}",
                                );
                            Navigator.pop(context);
                          },
                          child:
                              const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
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
                        "delete+${rental.id}"
                    ? CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.mainColor,
                        child: DotLoader(showDots: 1, size: 8),
                      )
                    : Icon(Icons.delete, color: Colors.red.shade400, size: 20),
                iconSize: 20,
                padding: EdgeInsets.all(8),
              ),
            ),
          ),
          // Right-top Status Label
          Positioned(
            right: 8,
            top: 8,
            child: _statusLabel(rental.deliverd.toString()),
          ),
        ],
      ),
    );
  }

  Widget _statusLabel(String? status) {
    Color bgColor = AppColors.mainColor;
    String label = "Active";

    if (status.toString() == "0") {
      bgColor = Colors.orange;
      label = "Pending";
    } else if (status.toString() == "1") {
      bgColor = AppColors.mainColor;
      label = "Rented";
    } else {
      bgColor = Colors.green;
      label = "Completed";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
