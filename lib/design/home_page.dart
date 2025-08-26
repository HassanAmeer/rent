import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/apidata/dashboardapi.dart';
import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/constants/appColors.dart';
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
import 'package:rent/constants/data.dart';
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

  // Helper method to parse double lists safely
  List<double> _parseDynamicList(dynamic data, List<double> defaultValue) {
    if (data == null || data is! List) {
      return defaultValue;
    }

    try {
      return data.map((e) {
        if (e == null) return 0.0;
        if (e is double) return e;
        if (e is int) return e.toDouble();
        if (e is String) return double.tryParse(e) ?? 0.0;
        return 0.0;
      }).toList();
    } catch (e) {
      print("Error parsing double list: $e");
      return defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardService = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(imgAssets.logo, width: 100),
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
                url: Config.imgUrl + ref.watch(userDataClass).userdata['image'],
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
            SizedBox(height: 25),

            // ✅ Sirf API wala chart
            HomeChart(
              bookingsData:
                  ref.watch(dashboardProvider).loadingfor == "dashboard "
                  ? [0, 0, 0, 0, 0, 0, 0, 0]
                  : _parseDynamicList(
                      dashboardService.dashboardData['orderCountsListForChart'],
                      [0, 0, 0, 0, 0, 0, 0, 0],
                    ),
              rentalsData:
                  ref.watch(dashboardProvider).loadingfor == "dashboard "
                  ? [0, 0, 0, 0, 0, 0, 0, 0]
                  : _parseDynamicList(
                      dashboardService
                          .dashboardData["rentalCountsListForChart"],
                      [],
                    ),
              labels: ref.watch(dashboardProvider).loadingfor == "dashboard "
                  ? []
                  : List<String>.from(
                      dashboardService
                              .dashboardData["productTitelsListForChart"] ??
                          [],
                    ),
            ),
            const SizedBox(height: 26),

            const SizedBox(height: 10),

            // ✅ Earnings & Rating Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Earning",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          ref.watch(dashboardProvider).loadingfor ==
                                  "dashboard "
                              ? "\$0.00"
                              : dashboardService.dashboardData['totalEarning']
                                        ?.toString() ??
                                    '\$0.00',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Rating",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          ref.watch(dashboardProvider).loadingfor ==
                                  "dashboard "
                              ? "0.0"
                              : dashboardService
                                        .dashboardData['totalReviewsRatio']
                                        ?.toString() ??
                                    '0.0',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ✅ Favorities & Rentals Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Favourite()),
                      );
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
                            Icon(
                              Icons.bookmark_border,
                              color: AppColors.mainColor,
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "My Favorities",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyRentalPage(),
                        ),
                      );
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
                          children: const [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: AppColors.mainColor,
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "My Rentals",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ Help & Blogs Row
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Help()),
                      );
                    },
                    child: Container(
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.support_agent,
                            color: AppColors.mainColor,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Help & support",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 12, 12, 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Blogs()),
                      );
                    },
                    child: Container(
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            color: AppColors.mainColor,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Blogs",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ✅ All Items Button
            InkWell(
              onTap: () {
                goto(AllItemsPage());
              },
              child: Container(
                width: 300,
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
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBarWidget(currentIndex: 0),
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
        const Text(
          "Overall",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

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

        const SizedBox(height: 18),

        SizedBox(
          height: 300,
          child: ref.watch(dashboardProvider).loadingfor == "dashboard"
              ? const Center(child: DotLoader())
              : LineChart(
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
