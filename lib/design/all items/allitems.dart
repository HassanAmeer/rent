import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/data.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/all%20items/allitemdetails.dart';
import 'package:rent/design/fav/fvrt.dart';
import 'package:rent/design/listing/ListingDetailPage.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/widgets/btmnavbar.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:intl/intl.dart';
import '../../apidata/allitemsapi.dart';
import '../../apidata/favrtapi.dart';
import '../../apidata/user.dart';
// import '../../design/orders/mybooking.dart';
import '../booking/my_booking_page.dart'; // ✅ Import MyBooking page

class AllItemsPage extends ConsumerStatefulWidget {
  const AllItemsPage({super.key});

  @override
  ConsumerState<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends ConsumerState<AllItemsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref
          .read(getAllItems)
          .fetchAllItems(loadingfor: "loadFullData", search: "asdf");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var allItemsList = ref.watch(getAllItems).allItems;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
        ),
        title: const Text(
          "All Items",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(



        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 25),

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
                            childAspectRatio: 0.75,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                      itemCount: allItemsList.length,
                      itemBuilder: (context, index) {
                        final item = allItemsList[index];

                        // return Text(item.toString());
                        return GestureDetector(
                          onTap: () {
                            goto(Allitemdetailspage(fullData: item));
                          },
                          child: ListingBox(
                            fullDataBytIndex: item,
                            id: item['id'].toString(),
                            title: item['title'] ?? 'No Name',
                            imageUrl: item['images'].toList().isEmpty
                                ? ImgLinks.product
                                : (Config.imgUrl + item['images'][0]) ??
                                      ImgLinks.product,
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 1),
    );
  }
}

class ListingBox extends ConsumerStatefulWidget {
  final fullDataBytIndex;
  final String title;
  final String imageUrl;
  final String id;

  const ListingBox({
    super.key,
    this.fullDataBytIndex,
    required this.title,
    required this.imageUrl,
    required this.id,
  });

  @override
  ConsumerState<ListingBox> createState() => _ListingBoxState();
}

class _ListingBoxState extends ConsumerState<ListingBox> {
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
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                ),
                // ✅ Favourite Button (Top Right)
                Positioned(
                  top: 5,
                  right: 5,
                  child: ref.watch(favrtdata).loadingFor == widget.id.toString()
                      ? DotLoader(showDots: 1)
                      : GestureDetector(
                          onTap: () {
                            ref
                                .watch(favrtdata)
                                .addfavrt(
                                  uid: ref
                                      .watch(userDataClass)
                                      .userdata['id']
                                      .toString(),
                                  itemId: widget.id.toString(),
                                  loadingFor: widget.id.toString(),
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
                                    .watch(favrtdata)
                                    .favrt
                                    .any(
                                      (i) =>
                                          i['itemId'].toString() ==
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
                          child: DotLoader(showDots: 1),
                        )
                      : GestureDetector(
                          onTap: () async {
                            try {
                              List<DateTime?> _dates = [];

                              var results = await showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                      calendarType:
                                          CalendarDatePicker2Type.range,
                                    ),
                                dialogSize: const Size(325, 400),
                                value: _dates,
                                borderRadius: BorderRadius.circular(15),
                              );

                              if (results!.isEmpty) {
                                toast("Plz Pickup date range");
                              }

                              // print(results.toString());
                              var startDate = results?.first; // DateTime
                              var endDate = results?.last; // DateTime

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
                                (int.parse(
                                          widget.fullDataBytIndex['dailyrate'],
                                        ) *
                                        daysCount)
                                    .toString(),
                              );
                              // return;
                              ref
                                  .read(getAllItems)
                                  .orderitems(
                                    userCanPickupInDateRange: finalDateRange,
                                    productId: widget.id,
                                    totalprice_by:
                                        (int.parse(
                                                  widget
                                                      .fullDataBytIndex['dailyrate'],
                                                ) *
                                                daysCount)
                                            .toString(),
                                    product_by:
                                        widget.fullDataBytIndex['dailyrate'],

                                    userId: ref
                                        .watch(userDataClass)
                                        .userdata['id']
                                        .toString(),

                                    loadingFor: widget.id + "order",

                                    context: context,
                                  );
                            } catch (e) {
                              toast("Plz Pickup date range");
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
