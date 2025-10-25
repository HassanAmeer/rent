import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
// import 'package:rent/apidata/myrentalapi.dart' show rentalDataProvider;
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
import '../../models/rent_in_model.dart';
import '../../widgets/btmnavbar.dart';

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
          .read(rentalDataProvider)
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
    final rentalData = ref.watch(rentalDataProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const Text(
          "  Rent In",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 2),

      body: Column(
        children: [
          rentalData.loadingFor == "refresh"
              ? QuickTikTokLoader(
                  progressColor: Colors.black,
                  backgroundColor: Colors.grey,
                )
              : SizedBox.shrink(),

          // Search bar just below AppBar (with grey background)
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: searchfeildcontroller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    final userId = ref.read(userDataClass).userId;
                    ref
                        .watch(rentalDataProvider)
                        .fetchRentIn(
                          userId: userId,
                          search: searchfeildcontroller.text,
                        );
                  },
                  icon: const Icon(Icons.search),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.white,
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

          // Rentals content with loading and empty states
          Expanded(
            child: rentalData.loadingFor == "fetchRentIn"
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: DotLoader(),
                    ),
                  )
                : rentalData.rentInListData.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No Rentals Found",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Your rental items will appear here",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      final userId = ref.read(userDataClass).userId;
                      await ref
                          .read(rentalDataProvider)
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Mobile 2 columns
                            mainAxisSpacing: 18,
                            crossAxisSpacing: 18,
                            childAspectRatio: 0.85,
                          ),
                      itemBuilder: (context, index) => _buildRentalItem(
                        context,
                        rentalData.rentInListData[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goto(AllItemsPage()); // Add new rental logic here
        },
        backgroundColor: AppColors.btnBgColor,
        child: Icon(Icons.add, color: AppColors.btnIconColor),
      ),
    );
  }

  Widget _buildRentalItem(BuildContext context, RentInModel rental) {
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
              const SizedBox(width: 6),
              // Main content (image and texts, centered)
              Expanded(
                child: InkWell(
                  onTap: () {
                    goto(RentInDetailsPage(renting: rental));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 90,
                            width: 130,
                            child: FittedBox(
                              fit: BoxFit.cover, // ✅ hamesha container me fit
                              child: CacheImageWidget(
                                isCircle: false,
                                url: rental.productImage.first,
                                height: 90,
                                width: 130,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          rental.productTitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          rental.productby?.name ?? '',
                          style: const TextStyle(
                            fontSize: 13,
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
              ),
            ],
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
