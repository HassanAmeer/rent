import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:rent/apidata/myrentalapi.dart' show rentalDataProvider;
// import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/design/all%20items/allitems.dart';
// import 'package:rent/design/myrentals/itemsrent.dart';
import 'package:rent/design/myrentals/rentaldetails.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../apidata/myrentalapi.dart';
import '../../apidata/user.dart';

class MyRentalPage extends ConsumerStatefulWidget {
  const MyRentalPage({super.key});

  @override
  ConsumerState<MyRentalPage> createState() => _MyRentalPageState();
}

class _MyRentalPageState extends ConsumerState<MyRentalPage> {
  var searchfeildcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(userDataClass).userdata['id']?.toString() ?? '1';
      ref
          .read(rentalDataProvider)
          .fetchMyRentals(
            userId: userId,
            loadingFor: "fetchMyRentals",
            search: "",
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final rentalData = ref.watch(rentalDataProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          "My Rentals",
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
              controller: searchfeildcontroller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    final userId =
                        ref.read(userDataClass).userdata['id']?.toString() ??
                        '1';
                    ref
                        .watch(rentalDataProvider)
                        .fetchMyRentals(
                          userId: userId,
                          search: searchfeildcontroller.text,
                        );
                  },
                  icon: Icon(Icons.search),
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
            child: rentalData.isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: DotLoader(),
                    ),
                  )
                : rentalData.rentals.isEmpty
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
                      final userId =
                          ref.read(userDataClass).userdata['id']?.toString() ??
                          '1';
                      await ref
                          .read(rentalDataProvider)
                          .fetchMyRentals(
                            userId: userId,
                            loadingFor: "refreshRentals",
                            search: "",
                          );
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: rentalData.rentals.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Mobile 2 columns
                            mainAxisSpacing: 18,
                            crossAxisSpacing: 18,
                            childAspectRatio: 0.85,
                          ),
                      itemBuilder: (context, index) =>
                          _buildRentalItem(context, rentalData.rentals[index]),
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

      // Floating Action Button for Add New rental

      // bottomNavigationBar: BottomNavBarWidget(currentIndex: 2),
    );
  }

  Widget _buildRentalItem(BuildContext context, dynamic rental) {
    // ✅ Fixed status: No backend/API logic now, always shows "Delivered"
    const status = 'Delivered';
    final statusColor = Colors.green;

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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 6,
                ),
              ),

              // Main content (image and texts, centered)
              InkWell(
                onTap: () {
                  goto(Rentaldetails(renting: rental));
                },
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CacheImageWidget(
                            isCircle: false,
                            url: _getImageUrl(rental),
                            height: 85,
                            width: 100,
                          ),
                        ),
                        Text(
                          _getProductTitle(rental),
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
                          _getUserName(rental),
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
            child: _statusLabel(rental["deliverd"].toString()),
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

  // Helper method to safely get image URL
  String _getImageUrl(dynamic rental) {
    try {
      if (rental['productImage'] != null) {
        var images = jsonDecode(rental['productImage']);
        if (images is List && images.isNotEmpty) {
          return Config.imgUrl + images[0];
        }
      }
    } catch (e) {
      print("Error parsing image: $e");
    }
    return ImgLinks.product;
  }

  // Helper method to safely get user name
  String _getUserName(dynamic rental) {
    try {
      if (rental['orderby'] != null && rental['orderby']['name'] != null) {
        return rental['orderby']['name'].toString();
      }
      // Try alternative field names
      if (rental['user'] != null && rental['user']['name'] != null) {
        return rental['user']['name'].toString();
      }
      if (rental['productby']["name"] != null) {
        return rental['productby']["name"].toString();
      }
    } catch (e) {
      print("Error getting user name: $e");
    }
    return "Unknown User";
  }

  // Helper method to safely get product title
  String _getProductTitle(dynamic rental) {
    try {
      if (rental['productTitle'] != null) {
        return rental['productTitle'].toString();
      }
      if (rental['title'] != null) {
        return rental['title'].toString();
      }
      if (rental['name'] != null) {
        return rental['name'].toString();
      }
    } catch (e) {
      print("Error getting product title: $e");
    }
    return "Unknown Product";
  }
}
