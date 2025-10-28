import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/design/all%20items/allitemdetails.dart';
import 'package:rent/design/fav/fav_items.dart';
import 'package:rent/design/listing/ListingDetailPage.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/widgets/btmnavbar.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:intl/intl.dart';
import '../../apidata/allitemsapi.dart';
import '../../apidata/favrtapi.dart';
import '../../apidata/user.dart';
import '../../constants/appColors.dart';
import '../../models/item_model.dart';
// import '../../design/orders/mybooking.dart';
import '../../widgets/listings_widgets/items_box_widget.dart';
import '../../widgets/searchfield.dart';
import '../rentout/rent_out_page.dart'; // ✅ Import MyBooking page

class AllItemsPage extends ConsumerStatefulWidget {
  const AllItemsPage({super.key});

  @override
  ConsumerState<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends ConsumerState<AllItemsPage> {
  var searchfieldcontroller = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref
          .read(getAllItems)
          .fetchAllItems(loadingfor: "loadFullData", search: "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ItemModel> allItemsList = ref.watch(getAllItems).allItems;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "All Items",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),

      /// Bottom Navigation
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref
                .read(getAllItems)
                .fetchAllItems(
                  loadingfor: "refresh",
                  search: "",
                  refresh: true,
                );
          },
          child: Column(
            children: [
              ref.watch(getAllItems).loadingFor == "refresh"
                  ? Container(
                      height: 60,
                      child: QuickTikTokLoader(
                        progressColor: AppColors.mainColor,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ).animate().fadeIn(duration: Duration(milliseconds: 300))
                  : SizedBox.shrink(),
              SizedBox(height: 8),
              Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                      child: SearchFeildWidget(
                        searchFieldController: searchfieldcontroller,
                        hint: "Search items & more...",
                        onSearchIconTap: () {
                          if (searchfieldcontroller.text.isEmpty) {
                            toast("Write Something");
                            return;
                          }
                          ref
                              .read(getAllItems)
                              .fetchAllItems(
                                refresh: true,
                                loadingfor: "refresh",
                                search: searchfieldcontroller.text,
                              );
                        },
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 300),
                    duration: Duration(milliseconds: 800),
                  )
                  .slideY(begin: -0.1),
              const SizedBox(height: 7),

              ref.watch(getAllItems).loadingFor == "loadFullData"
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
                                  "Loading items...",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: Duration(milliseconds: 500))
                        .scale()
                  : Expanded(
                      child: allItemsList.isEmpty
                          ? Center(
                                  child: Container(
                                    padding: EdgeInsets.all(32),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.mainColor
                                              .withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 80,
                                          color: AppColors.mainColor,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "No Items Found",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "No items available at the moment",
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
                                .fadeIn(
                                  delay: Duration(milliseconds: 500),
                                  duration: Duration(milliseconds: 800),
                                )
                                .scale()
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        ScreenSize.isLandscape ||
                                            ScreenSize.isTablet
                                        ? 3
                                        : 2,
                                    childAspectRatio: 0.9,
                                    mainAxisSpacing:
                                        ScreenSize.isLandscape ||
                                            ScreenSize.isTablet
                                        ? 25
                                        : 15,
                                    crossAxisSpacing:
                                        ScreenSize.isLandscape ||
                                            ScreenSize.isTablet
                                        ? 25
                                        : 15,
                                  ),
                              shrinkWrap: true,
                              controller: ScrollController(),
                              itemCount: allItemsList.length,
                              itemBuilder: (context, index) {
                                final item = allItemsList[index];

                                return ListingBox(
                                      id: item.id.toString(),
                                      title: item.displayTitle,
                                      showFav: true,
                                      onFavTap: () {
                                        ref
                                            .read(favProvider)
                                            .togglefavrt(
                                              uid: ref
                                                  .watch(userDataClass)
                                                  .userId,
                                              itemId: item.id.toString(),
                                              loadingFor: "${item.id}fav",
                                            );
                                      },
                                      isFavLoading:
                                          ref.watch(favProvider).loadingFor ==
                                              "${item.id}fav"
                                          ? true
                                          : false,

                                      isFavFilled: ref
                                          .watch(favProvider)
                                          .favouriteItems
                                          .any(
                                            (i) =>
                                                i.itemId.toString() ==
                                                item.id.toString(),
                                          ),
                                      showCart: true,
                                      isCartFilled: ref
                                          .watch(favProvider)
                                          .favouriteItems
                                          .any(
                                            (i) =>
                                                i.itemId.toString() ==
                                                item.id.toString(),
                                          ),
                                      isCartLoading:
                                          ref.watch(getAllItems).loadingFor ==
                                              "${item.id}order"
                                          ? true
                                          : false,
                                      onCartTap: () async {
                                        try {
                                          List<DateTime?> dates = [];
                                          var results =
                                              await showCalendarDatePicker2Dialog(
                                                context: context,
                                                config:
                                                    CalendarDatePicker2WithActionButtonsConfig(
                                                      calendarType:
                                                          CalendarDatePicker2Type
                                                              .range,
                                                    ),
                                                dialogSize: const Size(
                                                  325,
                                                  400,
                                                ),
                                                value: dates,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              );

                                          if (results!.isEmpty) {
                                            toast("Please Pickup date range");
                                          }

                                          // print(results.toString());
                                          var startDate =
                                              results.first; // DateTime
                                          var endDate =
                                              results.last; // DateTime

                                          // Formatter
                                          var formatter = DateFormat(
                                            "d MMMM yyyy",
                                          );

                                          // Convert to string
                                          var finalDateRange =
                                              "${formatter.format(startDate!)} to ${formatter.format(endDate!)}";
                                          // print(finalDateRange.toString());
                                          var daysCount =
                                              endDate
                                                  .difference(startDate)
                                                  .inDays +
                                              1;
                                          ////
                                          debugPrint(
                                            (item.dailyRate * daysCount)
                                                .toString(),
                                          );
                                          // return;
                                          ref
                                              .read(getAllItems)
                                              .orderitems(
                                                userCanPickupInDateRange:
                                                    finalDateRange,
                                                productId: item.id.toString(),
                                                totalprice_by:
                                                    (item.dailyRate * daysCount)
                                                        .toString(),
                                                product_by: item.user!.id
                                                    .toString(),
                                                userId: ref
                                                    .watch(userDataClass)
                                                    .userData["id"]
                                                    .toString(),
                                                loadingFor: "${item.id}order",
                                                context: context,
                                              );
                                        } catch (e) {
                                          debugPrint("error $e");
                                          toast("Try Later! $e");
                                        }
                                      },

                                      imageUrl: item.images.first,
                                      onTap: () => goto(
                                        Allitemdetailspage(index: index),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(
                                      delay: Duration(
                                        milliseconds: index * 100,
                                      ),
                                      duration: 0.2.seconds,
                                    )
                                    .slideY(begin: 0.2);
                              },
                            ).animate().fadeIn(
                              delay: Duration(milliseconds: 500),
                              duration: Duration(milliseconds: 800),
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
