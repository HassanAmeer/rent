import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rent/apidata/allitemsapi.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/screensizes.dart';

import '../../apidata/categoryapi.dart';
import '../../apidata/favrtapi.dart';
import '../../apidata/user.dart';
import '../../constants/appColors.dart';
import '../../models/chatedUsersModel.dart';
import '../../services/goto.dart';
import '../../services/toast.dart';
import '../../widgets/casheimage.dart';
import '../../models/item_model.dart';
import '../../widgets/imageview.dart';
import '../../widgets/item_content_details_widget.dart';
import '../message/chat.dart';
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
    final itemIndex = ref.watch(getAllItems).allItems[widget.index];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, AppColors.mainColor.shade100],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        //   ),
        //   title: const Text(
        //     "Item Details",
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                if (itemIndex.user == null) {
                  toast("User not Available From Long Time!");
                  return;
                }
                goto(
                  Chats(
                    msgdata: ChatedUsersModel(
                      id: 1,
                      sid: int.tryParse(
                        ref.watch(userDataClass).userData["id"].toString(),
                      ),
                      rid: int.tryParse(itemIndex.user!.id.toString()),
                      msg: "",
                      fromuid: ChatUser(
                        id: int.tryParse(
                          ref.watch(userDataClass).userData["id"].toString(),
                        ),
                        image: ref
                            .watch(userDataClass)
                            .userData["image"]
                            .toString(),
                        name: ref
                            .watch(userDataClass)
                            .userData["name"]
                            .toString(),
                      ),
                      touid: ChatUser(
                        id: int.tryParse(itemIndex.user!.id.toString()),
                        image: itemIndex.user!.image.toString(),
                        name: itemIndex.user!.name.toString(),
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.chat_outlined,
                size: 22,
                color: Colors.white,
              ),
            ).animate().scale(
              delay: Duration(milliseconds: 300),
              duration: Duration(milliseconds: 500),
            ),
            SizedBox(height: 15),

            FloatingActionButton(
              onPressed: () async {
                try {
                  if (itemIndex.user == null) {
                    toast("User not Available From Long Time!");
                    return;
                  }
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
                  debugPrint((itemIndex.dailyRate * daysCount).toString());
                  ref
                      .read(getAllItems)
                      .orderitems(
                        userCanPickupInDateRange: finalDateRange,
                        productId: itemIndex.id.toString(),
                        totalprice_by: (itemIndex.dailyRate * daysCount)
                            .toString(),
                        product_by: itemIndex.user!.id.toString(),
                        userId: ref
                            .watch(userDataClass)
                            .userData["id"]
                            .toString(),
                        loadingFor: "${itemIndex.id}order",
                        context: context,
                      );
                } catch (e) {
                  toast("Try later! $e");
                }
              },

              child: ref.watch(getAllItems).loadingFor == "${itemIndex.id}order"
                  ? Padding(
                      padding: const EdgeInsets.all(15),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      ref.watch(getAllItems).orderedItems.contains(itemIndex.id)
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
                      itemId: itemIndex.id.toString(),
                      loadingFor: "${itemIndex.id}fav",
                    );
              },
              child: ref.watch(favProvider).loadingFor == "${itemIndex.id}fav"
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
                        .any(
                          (i) => i.itemId.toString() == itemIndex.id.toString(),
                        )
                  ? const Icon(Icons.bookmark, size: 22, color: Colors.white)
                  : const Icon(
                      Icons.bookmark_border,
                      size: 22,
                      color: Colors.white,
                    ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: ScrollController(),
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: const Text(
                //     "Item Details",
                //     style: TextStyle(color: Colors.black, fontSize: 20),
                //   ),
                // ),
                ItemContentDetailsWidget(
                  images: itemIndex.images,
                  title: itemIndex.displayTitle,
                  description: itemIndex.description,
                  catgName:
                      "${itemIndex.categoryId != null
                          ? ref.watch(categoryProvider).categories.where((e) => e.id == itemIndex.categoryId).isNotEmpty
                                ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == itemIndex.categoryId).name
                                : null
                          : null}",
                  catgImg:
                      "${itemIndex.categoryId != null
                          ? ref.watch(categoryProvider).categories.where((e) => e.id == itemIndex.categoryId).isNotEmpty
                                ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == itemIndex.categoryId).image
                                : null
                          : null}",
                  dailyRate: itemIndex.dailyRate.toString(),
                  weeklyRate: itemIndex.weeklyRate.toString(),
                  monthlyRate: itemIndex.monthlyRate.toString(),
                  availability: itemIndex.availabilityRange ?? '',
                  listingDate: itemIndex.createdAt.toString(),
                  // orderDate: orderDate,
                  userImage: itemIndex.user?.image,
                  userName: itemIndex.user?.name,
                  userEmail: itemIndex.user?.email,
                  userPhone: itemIndex.user?.phone,
                  userAddress: itemIndex.user?.address,
                  userAbout: itemIndex.user?.aboutUs,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
