import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
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
import '../../models/item_model.dart';
// import '../../design/orders/mybooking.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
        title: const Text(
          "All Items",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),

      /// Bottom Navigation
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  ? Transform.scale(
                      scale: 1.2,
                      child: QuickTikTokLoader(
                        progressColor: Colors.black,
                        backgroundColor: Colors.grey,
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 3,
                ),
                child: SearchFeildWidget(
                  searchFieldController: searchfieldcontroller,
                  hint: "Search items...",
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
              const SizedBox(height: 7),

              ref.watch(getAllItems).loadingFor == "loadFullData"
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 250),
                        child: DotLoader(),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.1,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemCount: allItemsList.length,
                        itemBuilder: (context, index) {
                          final item = allItemsList[index];

                          // return Text(item.toString());
                          return GestureDetector(
                            onTap: () {
                              goto(Allitemdetailspage(item: item));
                            },
                            child: ItemsBox(
                              fullDataBytIndex: item,
                              id: item.id.toString(),
                              title: item.displayTitle,
                              imageUrl: item.images.first,
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemsBox extends ConsumerStatefulWidget {
  final ItemModel fullDataBytIndex;
  final String title;
  final String imageUrl;
  final String id;

  const ItemsBox({
    super.key,
    required this.fullDataBytIndex,
    required this.title,
    required this.imageUrl,
    required this.id,
  });

  @override
  ConsumerState<ItemsBox> createState() => _ItemsBoxState();
}

class _ItemsBoxState extends ConsumerState<ItemsBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                CacheImageWidget(
                  isCircle: false,
                  url: widget.imageUrl,
                  width: ScreenSize.width * 0.46,
                  height: ScreenSize.height * 0.3,
                ),

                // ✅ Favourite Button (Top Right)
                Positioned(
                  top: 5,
                  right: 5,
                  child: ref.watch(favProvider).loadingFor == "${widget.id}fav"
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black87,
                          child: DotLoader(showDots: 1),
                        )
                      : GestureDetector(
                          onTap: () {
                            ref
                                .watch(favProvider)
                                .togglefavrt(
                                  uid: ref.watch(userDataClass).userId,
                                  itemId: widget.id.toString(),
                                  loadingFor: "${widget.id}fav",
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child:
                                ref
                                    .watch(favProvider)
                                    .favouriteItems
                                    .any(
                                      (i) =>
                                          i.itemId.toString() ==
                                          widget.id.toString(),
                                    )
                                ? const Icon(
                                    Icons.bookmark,
                                    size: 22,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.bookmark_border,
                                    size: 22,
                                    color: Colors.black,
                                  ),
                          ),
                        ),
                ),

                // ✅ Order Now Button (Top Left → Goes to MyBookingPage)
                Positioned(
                  top: 5,
                  left: 5,
                  child:
                      ref.watch(getAllItems).loadingFor == "${widget.id}order"
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black87,
                            child: DotLoader(showDots: 1),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            try {
                              List<DateTime?> dates = [];
                              var results = await showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                      calendarType:
                                          CalendarDatePicker2Type.range,
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
                              var daysCount =
                                  endDate.difference(startDate).inDays + 1;
                              ////
                              debugPrint(
                                (widget.fullDataBytIndex.dailyRate * daysCount)
                                    .toString(),
                              );
                              // return;
                              ref
                                  .read(getAllItems)
                                  .orderitems(
                                    userCanPickupInDateRange: finalDateRange,
                                    productId: widget.id,
                                    totalprice_by:
                                        (widget.fullDataBytIndex.dailyRate *
                                                daysCount)
                                            .toString(),
                                    product_by: widget
                                        .fullDataBytIndex
                                        .dailyRate
                                        .toString(),
                                    userId: ref.watch(userDataClass).userId,
                                    loadingFor: "${widget.id}order",
                                    context: context,
                                  );
                            } catch (e) {
                              debugPrint("error $e");
                              toast("Try Later! $e");
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              ref
                                      .watch(getAllItems)
                                      .orderedItems
                                      .contains(widget.id)
                                  ? Icons
                                        .shopping_cart // Filled cart
                                  : Icons
                                        .shopping_cart_outlined, // Outlined cart
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
