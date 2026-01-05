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
import 'package:rent/helpers/calendar_theme.dart';
import '../../apidata/allitemsapi.dart';
import '../../apidata/categoryapi.dart';
import '../../apidata/favrtapi.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../models/chat_model.dart' hide ChatUser;
import '../../models/chatedUsersModel.dart';
import '../../services/goto.dart';
import '../../services/toast.dart';
import '../../widgets/casheimage.dart';

import '../../models/item_model.dart';
import '../../models/favorite_model.dart';
import '../../widgets/imageview.dart';
import '../../widgets/item_content_details_widget.dart';
import '../message/chat.dart';

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
    try {
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
          //   elevation: 0,
          //   leading: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          //   ),
          //   backgroundColor: AppColors.mainColor,
          //   title: const Text(
          //     "Favourite Details",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //       fontSize: 20,
          //     ),
          //   ),
          //   iconTheme: const IconThemeData(color: Colors.white),
          //   actions: [
          //     IconButton(
          //       onPressed: () {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(
          //             content: Text("Bookmark toggled!"),
          //             backgroundColor: AppColors.mainColor,
          //           ),
          //         );
          //       },
          //       icon: Icon(Icons.bookmark_added, color: Colors.black),
          //     ).animate().scale(
          //       delay: Duration(milliseconds: 500),
          //       duration: Duration(milliseconds: 500),
          //     ),
          //   ],
          // ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  if (favitem.rentalusers == null) {
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
                        rid: favitem.rentalusers == null
                            ? null
                            : int.tryParse(favitem.rentalusers!.id.toString()),
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
                          id: favitem.rentalusers == null
                              ? null
                              : int.tryParse(
                                  favitem.rentalusers!.id.toString(),
                                ),
                          image: favitem.rentalusers?.image.toString(),
                          name: favitem.rentalusers?.name.toString(),
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
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onPressed: () async {
                  try {
                    if (favitem.products == null ||
                        favitem.rentalusers == null) {
                      toast("User not Available From Long Time!");
                      return;
                    }
                    List<DateTime?> dates = [];

                    var results = await showCalendarDatePicker2Dialog(
                      context: context,
                      config: CalendarTheme.getConfig(),
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
                          totalprice_by:
                              (favitem.products!.dailyrate * daysCount)
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
                    // toast("Try later! $e");
                    toast("Cancelled !");
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
                                  .calendar_month_sharp // Filled cart
                            : Icons.calendar_month_outlined, // Outlined cart
                        size: 22,
                        color: Colors.white,
                      ),
              ),
              SizedBox(height: 10),
              FloatingActionButton.small(
                backgroundColor: Colors.black,
                onPressed: () async {
                  await ref
                      .watch(favProvider)
                      .togglefavrt(
                        uid: ref.watch(userDataClass).userId,
                        itemId: favitem.id.toString(),
                        loadingFor: "${favitem.id}fav",
                      )
                      .then((v) {
                        Navigator.pop(context);
                      });
                },
                child: ref.watch(favProvider).loadingFor == "${favitem.id}fav"
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
                            (i) => i.itemId.toString() == favitem.id.toString(),
                          )
                    ? const Icon(Icons.bookmark, size: 22, color: Colors.white)
                    : const Icon(Icons.bookmark, size: 22, color: Colors.white),
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                ItemContentDetailsWidget(
                  images: favitem.itemImages,
                  title: favitem.displayTitle,
                  description: favitem.itemDescription,
                  catgName: favitem.products == null
                      ? null
                      : "${favitem.products!.category != null
                            ? ref.watch(categoryProvider).categories.where((e) => e.id == favitem.products!.category).isNotEmpty
                                  ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == favitem.products!.category).name
                                  : null
                            : null}",
                  catgImg: favitem.products == null
                      ? null
                      : "${favitem.products!.category != null
                            ? ref.watch(categoryProvider).categories.where((e) => e.id == favitem.products!.category).isNotEmpty
                                  ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == favitem.products!.category).image
                                  : null
                            : null}",
                  dailyRate: favitem.products?.dailyrate.toString(),
                  weeklyRate: favitem.products?.weeklyrate.toString(),
                  monthlyRate: favitem.products?.monthlyrate.toString(),
                  availability: favitem.products == null
                      ? null
                      : favitem.products!.availabilityDays ?? '',
                  listingDate: favitem.products?.createdAt.toString(),
                  // orderDate: orderDate,
                  userImage: favitem.products == null
                      ? null
                      : favitem.rentalusers?.image,
                  userName: favitem.products == null
                      ? null
                      : favitem.rentalusers?.name,
                  userEmail: favitem.products == null
                      ? null
                      : favitem.rentalusers?.email,
                  userPhone: favitem.products == null
                      ? null
                      : favitem.rentalusers?.phone,
                  userAddress: favitem.products == null
                      ? null
                      : favitem.rentalusers?.address,
                  userAbout: favitem.products == null
                      ? null
                      : favitem.rentalusers?.aboutUs,
                  onBookNowTap: () async {
                    try {
                      if (favitem.products == null ||
                          favitem.rentalusers == null) {
                        toast("User not Available From Long Time!");
                        return;
                      }
                      List<DateTime?> dates = [];

                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarTheme.getConfig(),
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
                            totalprice_by:
                                (favitem.products!.dailyrate * daysCount)
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
                      // toast("Try later! $e");
                      toast("Cancelled !");
                    }
                  },
                ),
                Positioned(
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: const Offset(0, 0),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, st) {
      debugPrint("💥 try catch error in favdetails: $e, st:$st");
      return Text("$e");
    }
  }
}
