import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/apidata/dashboardapi.dart';
import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/design/all%20items/allitems.dart' show AllItemsPage;
import 'package:rent/design/blogs/blogs.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/design/fav/fav_items.dart';
import 'package:rent/design/help.dart';
import 'package:rent/design/listing/listing_page.dart' hide AllItemsPage;
import 'package:rent/design/rentout/rent_out_page.dart';
import 'package:rent/design/notify/notificationpage.dart';
import 'package:rent/design/rentin/rent_in_page.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import '../widgets/btmnavbar.dart';
import '../constants/checkInternet.dart';
import 'auth/profile_details_page.dart';

/// ✅ HomePage
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch dashboard data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check internet connection first
      if (await checkInternet() == false) {
        showErrorToast("No internet connection");
        return;
      }

      // Get user profile data
      await ref.read(userDataClass).getProfileData();

      // Fetch dashboard data with user ID
      final userId = ref.read(userDataClass).userId;
      if (userId.isNotEmpty) {
        ref
            .read(dashboardProvider)
            .fetchDashboard(loadingfor: "dashboard", uid: userId);
      } else {
        debugPrint("User ID not available for dashboard fetch");
      }
    });
  }

  /// Safely parse dynamic data to List<double> with error handling
  List<double> _parseDoubleList(dynamic data) {
    if (data == null) return [];

    try {
      if (data is List) {
        return data.map((e) {
          if (e is double) return e;
          if (e is int) return e.toDouble();
          if (e is String) return double.tryParse(e) ?? 0.0;
          return 0.0;
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error parsing double list: $e");
      return [];
    }
  }

  /// Safely parse dynamic data to List<String> with error handling
  List<String> _parseStringList(dynamic data) {
    if (data == null) return [];

    try {
      if (data is List) {
        return data.map((e) => e?.toString() ?? '').toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error parsing string list: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardService = ref.watch(dashboardProvider);

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Image.asset(ImgAssets.logoShadow, width: 100),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => NotificationPage(),
                  ),
                );
              },
              icon: const Icon(Icons.notifications, size: 30),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetailsPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.shade700,
                  borderRadius: BorderRadius.circular(25),
                ),
                width: 47,
                height: 47,
                clipBehavior: Clip.antiAlias,
                child: CacheImageWidget(
                  url: Api.imgPath + ref.watch(userDataClass).userImage,
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
        ),

        /// ✅ Body
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 0),

              // ✅ Sirf API wala chart
              ref.watch(dashboardProvider).loadingfor == "dashboard"
                  ? LoadingChart()
                  : HomeChart(
                          bookingsData: _parseDoubleList(
                            dashboardService
                                .dashboardData['orderCountsListForChart'],
                          ),
                          rentalsData: _parseDoubleList(
                            dashboardService
                                .dashboardData["rentalCountsListForChart"],
                          ),
                          labels: _parseStringList(
                            dashboardService
                                .dashboardData["productTitelsListForChart"],
                          ),
                        )
                        .animate(
                          // onPlay: (controller) => controller.repeat(),
                        )
                        .moveX(),

              // Text(
              //   "${dashboardService.dashboardData['orderCountsListForChart']}",
              // ),
              const SizedBox(height: 28),
              // ✅ Earnings & Rating Row
              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      homeTextWidget(
                        title: "Total Earning",
                        value:
                            "\$${dashboardService.dashboardData['totalEarning']?.toString() ?? '0.00'}",
                      ),
                      // const SizedBox(width: 12),
                      homeTextWidget(
                        title: " Total Rating",
                        value:
                            dashboardService.dashboardData['totalRating']
                                ?.toString() ??
                            "0.0",
                      ),
                    ],
                  )
                  .animate(
                    // onPlay: (controller) => controller.repeat(),
                  )
                  .moveX(duration: Duration(milliseconds: 1500))
                  .fadeIn(duration: Duration(milliseconds: 1500)),

              const SizedBox(height: 5),

              // ✅ Favorities & Rentals Row
              SizedBox(
                    height: ScreenSize.height * 0.19,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: [
                        homeMenuBoxWidget(
                          label: "My Favorities",
                          pageName: Favourite(),
                          icon: Icons.bookmark_border,
                        ),
                        homeMenuBoxWidget(
                          label: "Rent Outs",
                          pageName: RentOutPage(),
                          icon: Icons.calendar_month_outlined,
                        ),
                        homeMenuBoxWidget(
                          label: "Blogs",
                          pageName: Blogs(),
                          icon: Icons.article_outlined,
                        ),
                        homeMenuBoxWidget(
                          label: "Help & support",
                          pageName: Help(),
                          icon: Icons.support_agent,
                        ),
                      ],
                    ),
                  )
                  .animate(
                    // onPlay: (controller) => controller.repeat(),
                  )
                  .moveX(
                    duration: Duration(milliseconds: 800),
                    begin: 100,
                    end: 0,
                  )
                  .fadeIn(duration: Duration(milliseconds: 800)),

              const SizedBox(height: 5),

              // ✅ All Items Button
              InkWell(
                    onTap: () {
                      goto(ListingPage());
                    },
                    child:
                        Container(
                              width: ScreenSize.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(14),
                                child: Center(
                                  child: Text(
                                    "My Items",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(duration: Duration(seconds: 3)),
                  )
                  .animate(
                    // onPlay: (controller) => controller.repeat(),
                  )
                  .moveY(
                    duration: Duration(milliseconds: 800),
                    begin: 100,
                    end: 0,
                  )
                  .fadeIn(duration: Duration(milliseconds: 800)),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavBarWidget(currentIndex: 0),
      ),
    );
  }
}

class HomeChart extends ConsumerStatefulWidget {
  final List<double> bookingsData;
  final List<double> rentalsData;
  final List<String> labels;
  const HomeChart({
    super.key,
    required this.bookingsData,
    required this.rentalsData,
    required this.labels,
  });

  @override
  ConsumerState<HomeChart> createState() => _HomeChartState();
}

class _HomeChartState extends ConsumerState<HomeChart> {
  @override
  Widget build(BuildContext context) {
    debugPrint("👉🏻 Bookings Data: ${widget.bookingsData}");
    debugPrint("Rentals Data: ${widget.rentalsData}");

    double maxYValue = 0;
    if (widget.bookingsData.isNotEmpty) {
      maxYValue = widget.bookingsData.reduce(
        (curr, next) => curr > next ? curr : next,
      );
    }
    if (widget.rentalsData.isNotEmpty) {
      double maxRentalValue = widget.rentalsData.reduce(
        (curr, next) => curr > next ? curr : next,
      );
      if (maxRentalValue > maxYValue) {
        maxYValue = maxRentalValue;
      }
    }

    // Add some padding to the maxYValue for better visualization
    maxYValue = (maxYValue + 1).ceilToDouble();
    if (maxYValue < 5) maxYValue = 5; // Ensure a minimum maxY for small values

    return Column(
      children: [
        // const Text(
        //       "Overall",
        //       style: TextStyle(
        //         fontSize: 22,
        //         color: Colors.grey,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     )
        //     .animate(onPlay: (controller) => controller.repeat())
        //     .shimmer(
        //       // color: AppColors.mainColor.withOpacity(0.5),
        //       color: Colors.black,
        //       duration: Duration(seconds: 5),
        //     ),

        // const SizedBox(height: 8),

        // Legend Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(width: 20, height: 3, color: Colors.orange),
                const SizedBox(width: 5),
                const Text("Rent Outs"),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Container(width: 20, height: 3, color: Colors.blue),
                const SizedBox(width: 5),
                const Text("Rent In"),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: ScreenSize.height * 0.3,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < widget.labels.length) {
                        return Transform.rotate(
                          angle: -0.5,
                          child: Text(
                            widget.labels[value.toInt()].toString().length > 15
                                ? widget.labels[value.toInt()]
                                      .toString()
                                      .substring(0, 15)
                                : widget.labels[value.toInt()].toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 8),
                      );
                    },
                  ),
                ),
              ),
              minY: 0,
              maxY: maxYValue,
              lineBarsData: [
                LineChartBarData(
                  spots: widget.bookingsData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value);
                  }).toList(),
                  isCurved: false,
                  color: Colors.orange,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withOpacity(0.2),
                  ),
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots: widget.rentalsData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value);
                  }).toList(),
                  isCurved: false,
                  color: Colors.blue,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.2),
                  ),
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingChart extends StatelessWidget {
  const LoadingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
          opacity: 0.3,
          child: HomeChart(
            bookingsData: [0, 0, 0, 0, 0, 0, 0, 0],
            rentalsData: [0, 0, 0, 0, 0, 0, 0, 0],
            labels: ["@", "@", "@", "@", "@", "@", "@", "@"],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .saturate()
        .tint()
        .shimmer(color: Colors.grey, duration: Duration(milliseconds: 1000))
        .shimmer(color: Colors.white, duration: Duration(milliseconds: 1000))
        .shimmer(color: Colors.black, duration: Duration(milliseconds: 2500));
  }
}

/// Enhanced home text widget with better styling and error handling
Widget homeTextWidget({
  required String title,
  required String value,
  double titleFontSize = 14,
  double valueFontSize = 25,
  Color titleColor = Colors.grey,
  Color valueColor = Colors.grey,
  FontWeight titleWeight = FontWeight.normal,
  FontWeight valueWeight = FontWeight.bold,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: titleFontSize,
          color: titleColor,
          fontWeight: titleWeight,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: valueFontSize,
          color: valueColor,
          fontWeight: valueWeight,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

/// Enhanced home menu box widget with better styling and error handling
Widget homeMenuBoxWidget({
  required String label,
  required IconData icon,
  Widget? pageName,
  double width = 145,
  double height = 120,
  double iconSize = 50,
  Color backgroundColor = Colors.white,
  Color iconColor = Colors.cyan,
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
  EdgeInsets padding = const EdgeInsets.all(18),
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: InkWell(
      onTap:
          onTap ??
          () {
            if (pageName != null) {
              goto(pageName);
            }
          },
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: iconSize),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
