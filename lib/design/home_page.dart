import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/apidata/dashboardapi.dart';
import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/all%20items/allitems.dart' show AllItemsPage;
import 'package:rent/design/blogs/Blogs.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/design/fav/fvrt.dart';
import 'package:rent/design/help.dart';
import 'package:rent/design/listing/listing_page.dart' hide AllItemsPage;
import 'package:rent/design/booking/my_booking_page.dart';
import 'package:rent/design/notify/notificationpage.dart';
import 'package:rent/design/myrentals/myrentalpage.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import '../Auth/profile_details_page.dart';
import '../widgets/btmnavbar.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(userDataClass).getProfileData();
      ref
          .read(dashboardProvider)
          .fetchDashboard(
            loadingfor: "dashboard",
            uid: "${ref.watch(userDataClass).userdata['id']}",
          );
    });
  }

  List<double> _parseDoubleList(dynamic data) {
    if (data == null) return [];

    try {
      if (data is List) {
        return data.map((e) {
          if (e is double) return e;
          if (e is int) return e.toDouble();
          if (e is String) return double.parse(e);
          return 0.0;
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  List<String> _parseStringList(dynamic data) {
    if (data == null) return [];

    try {
      if (data is List) {
        return data.map((e) {
          return e.toString();
        }).toList();
      }
      return [];
    } catch (e) {
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
          title: Image.asset(ImgAssets.logo, width: 100),
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
                  url:
                      Config.imgUrl +
                      ref.watch(userDataClass).userdata['image'],
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
        ),

        /// ✅ Body
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 5),

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
                                .dashboardData["productTitelsListForChart"]
                                .map((e) => e.toString()),
                          ),
                        )
                        .animate(
                          // onPlay: (controller) => controller.repeat(),
                        )
                        .moveX(),

              // Text(
              //   "${dashboardService.dashboardData['orderCountsListForChart']}",
              // ),
              const SizedBox(height: 5),
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
                          label: "My Rentals",
                          pageName: MyRentalPage(),
                          icon: Icons.shopping_cart_outlined,
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
                      goto(AllItemsPage());
                    },
                    child:
                        Container(
                              width: ScreenSize.width* 0.9,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(14),
                                child: Center(
                                  child: Text(
                                    "All Items",
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
                const Text("My Bookings"),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Container(width: 20, height: 3, color: Colors.blue),
                const SizedBox(width: 5),
                const Text("My Rentals"),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 288,
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
                            widget.labels[value.toInt()],
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
                    interval: 0.5,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              minY: 0,
              maxY: 3,
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

homeTextWidget({required String title, required String value}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(
          // fontWeight: FontWeight.bold,
          color: AppColors.mainColor.shade300,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 25,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

homeMenuBoxWidget({
  String label = "",
  IconData icon = Icons.menu,
  Widget? pageName,
}) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: InkWell(
      onTap: () {
        if (pageName != null) {
          goto(pageName);
        }
      },
      child: Container(
        width: 145,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.mainColor, size: 50),
              const SizedBox(height: 10),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    ),
  );
}
