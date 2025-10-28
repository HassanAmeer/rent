import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/screensizes.dart';
import '../../apidata/allitemsapi.dart';
import '../../apidata/categoryapi.dart';
import '../../apidata/favrtapi.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../services/toast.dart';
import '../../widgets/casheimage.dart';

import '../../models/item_model.dart';
import '../../models/favorite_model.dart';
import '../../widgets/imageview.dart';
import '../../widgets/item_content_details_widget.dart';

class FavDetailsPage extends ConsumerStatefulWidget {
  final int index;

  const FavDetailsPage({super.key, required this.index});

  @override
  _FavDetailsPageState createState() => _FavDetailsPageState();
}

class _FavDetailsPageState extends ConsumerState<FavDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var favitem = ref.watch(favProvider).favouriteItems[widget.index];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: const Text(
          "Favourite Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
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
            ),
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Bookmark toggled!"),
                    backgroundColor: AppColors.mainColor,
                  ),
                );
              },
              icon: Icon(Icons.bookmark_added, color: AppColors.mainColor),
            ),
          ).animate().scale(
            delay: Duration(milliseconds: 500),
            duration: Duration(milliseconds: 500),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.mainColor,
            foregroundColor: Colors.white,
            onPressed: () {},
            child: const Icon(Icons.chat_outlined, size: 22),
          ).animate().scale(
            delay: Duration(milliseconds: 300),
            duration: Duration(milliseconds: 500),
          ),
          SizedBox(height: 15),

          FloatingActionButton(
            backgroundColor: AppColors.mainColor,
            foregroundColor: Colors.white,
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
                debugPrint(
                  (favitem.products!.dailyrate * daysCount).toString(),
                );
                ref
                    .read(getAllItems)
                    .orderitems(
                      userCanPickupInDateRange: finalDateRange,
                      productId: favitem.products!.id.toString(),
                      totalprice_by: (favitem.products!.dailyrate * daysCount)
                          .toString(),
                      product_by: favitem.rentalusers!.id.toString(),
                      userId: ref
                          .watch(userDataClass)
                          .userData["id"]
                          .toString(),
                      loadingFor: "${favitem.id}order",
                      context: context,
                    );
              } catch (e) {
                toast("Try later! $e");
              }
            },

            child: ref.watch(getAllItems).loadingFor == "${favitem.id}order"
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    ref.watch(getAllItems).orderedItems.contains(favitem.id)
                        ? Icons
                              .shopping_cart // Filled cart
                        : Icons.shopping_cart_outlined, // Outlined cart
                    size: 22,
                    color: Colors.white,
                  ),
          ),
        ],
      ),
      body: ItemContentDetailsWidget(
        images: favitem.itemImages,
        title: favitem.displayTitle,
        description: favitem.itemDescription,
        catgName:
            "${favitem.products!.category != null
                ? ref.watch(categoryProvider).categories.where((e) => e.id == favitem.products!.category).isNotEmpty
                      ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == favitem.products!.category).name
                      : null
                : null}",
        catgImg:
            "${favitem.products!.category != null
                ? ref.watch(categoryProvider).categories.where((e) => e.id == favitem.products!.category).isNotEmpty
                      ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == favitem.products!.category).image
                      : null
                : null}",
        dailyRate: favitem.products!.dailyrate.toString(),
        weeklyRate: favitem.products!.weeklyrate.toString(),
        monthlyRate: favitem.products!.monthlyrate.toString(),
        availability: favitem.products!.availabilityDays ?? '',
        listingDate: favitem.products!.createdAt.toString(),
        // orderDate: orderDate,
        userImage: favitem.rentalusers?.image,
        userName: favitem.rentalusers?.name,
        userEmail: favitem.rentalusers?.email,
        userPhone: favitem.rentalusers?.phone,
        userAddress: favitem.rentalusers?.address,
        userAbout: favitem.rentalusers?.aboutUs,
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              style: TextStyle(
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
