import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rent/apidata/allitemsapi.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/screensizes.dart';

import '../../apidata/categoryapi.dart';
import '../../apidata/favrtapi.dart';
import '../../apidata/user.dart';
import '../../services/toast.dart';
import '../../widgets/casheimage.dart';
import '../../models/item_model.dart';
import '../../widgets/imageview.dart';
// ✅ Edit page import

class Allitemdetailspage extends ConsumerStatefulWidget {
  final int index;

  const Allitemdetailspage({super.key, required this.index});

  @override
  ConsumerState<Allitemdetailspage> createState() => _AllitemdetailspageState();
}

class _AllitemdetailspageState extends ConsumerState<Allitemdetailspage> {
  @override
  Widget build(BuildContext context) {
    final item = ref.watch(getAllItems).allItems[widget.index];
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {},
            child: const Icon(
              Icons.chat_outlined,
              size: 22,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),

          FloatingActionButton(
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
                debugPrint((item.dailyRate * daysCount).toString());
                ref
                    .read(getAllItems)
                    .orderitems(
                      userCanPickupInDateRange: finalDateRange,
                      productId: item.id.toString(),
                      totalprice_by: (item.dailyRate * daysCount).toString(),
                      product_by: item.user!.id.toString(),
                      userId: ref
                          .watch(userDataClass)
                          .userData["id"]
                          .toString(),
                      loadingFor: "${item.id}order",
                      context: context,
                    );
              } catch (e) {
                toast("Try later! $e");
              }
            },

            child: ref.watch(getAllItems).loadingFor == "${item.id}order"
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    ref.watch(getAllItems).orderedItems.contains(item.id)
                        ? Icons
                              .shopping_cart // Filled cart
                        : Icons.shopping_cart_outlined, // Outlined cart
                    size: 22,
                    color: Colors.white,
                  ),
          ),
          SizedBox(height: 15),
          FloatingActionButton.small(
            backgroundColor: Colors.black,
            onPressed: () {
              ref
                  .watch(favProvider)
                  .togglefavrt(
                    uid: ref.watch(userDataClass).userId,
                    itemId: item.id.toString(),
                    loadingFor: "${item.id}fav",
                  );
            },
            child: ref.watch(favProvider).loadingFor == "${item.id}fav"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : ref
                      .watch(favProvider)
                      .favouriteItems
                      .any((i) => i.itemId.toString() == item.id.toString())
                ? const Icon(Icons.bookmark, size: 22, color: Colors.white)
                : const Icon(
                    Icons.bookmark_border,
                    size: 22,
                    color: Colors.white,
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                itemCount: item.images.length,
                itemBuilder: (context, index, realIndex) {
                  final imageUrl = item.images[index];
                  return CacheImageWidget(
                    onTap: () {
                      showImageView(context, imageUrl);
                    },
                    width: double.infinity,
                    height: ScreenSize.height * 0.3,
                    isCircle: false,
                    fit: BoxFit.contain,
                    radius: 0,
                    url: imageUrl,
                  );
                },
                options: CarouselOptions(
                  height: ScreenSize.height * 0.35,
                  viewportFraction: 0.68,
                  enlargeCenterPage: true,
                  autoPlay: item.images.length > 1,
                  autoPlayInterval: const Duration(seconds: 2),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: item.images.length > 1,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                item.displayTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              HtmlWidget(item.description ?? 'No description available'),

              SizedBox(height: 15),
              ListTile(
                tileColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.only(left: 5),

                leading: CacheImageWidget(
                  width: 25,
                  height: 25,
                  isCircle: true,
                  radius: 5,
                  url:
                      "${item.categoryId != null
                          ? ref.watch(categoryProvider).categories.where((e) => e.id == item.categoryId).isNotEmpty
                                ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == item.categoryId).image
                                : null
                          : null}",
                ),
                title: Text(
                  "${item.categoryId != null
                      ? ref.watch(categoryProvider).categories.where((e) => e.id == item.categoryId).isNotEmpty
                            ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == item.categoryId).name
                            : null
                      : null}",
                ),
                trailing: Text("Category  "),
              ),
              Divider(),

              ListTile(title: Text("Daily Rate: ${item.formattedDailyRate}")),
              Divider(),
              ListTile(title: Text("Weekly Rate: ${item.formattedWeeklyRate}")),
              Divider(),
              ListTile(
                title: Text("Monthly Rate: ${item.formattedMonthlyRate}"),
              ),

              Divider(),
              ListTile(
                title: Text(
                  "Availability: ${item.availabilityDays ?? 'Not specified'}",
                ),
              ),
              Divider(),

              // Item owner information
              if (item.user != null) ...[
                const ListTile(title: Text("From User")),
                ListTile(
                  leading: CacheImageWidget(
                    width: 50,
                    height: 50,
                    isCircle: true,
                    radius: 200,
                    url: item.user!.fullImageUrl.isNotEmpty
                        ? item.user!.fullImageUrl
                        : ImgLinks.profileImage,
                  ),
                  title: Text(item.user!.displayName),
                  subtitle: Text(item.user!.email),
                ),
              ],
              Divider(),
              ListTile(
                title: Text(
                  "Listing Date:",
                  style: TextStyle(color: Colors.grey),
                ),
                subtitle: Text(item.createdAt?.toString() ?? 'N/A'),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
