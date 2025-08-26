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
import '../Auth/profile_details_page.dart';
import '../widgets/btmnavbar.dart';

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
  void InitState() {
    super.initState();
    ref.read(dashboardProvider).fetchDashboard();
    uid:
    ref.watch(userDataClass).userdata['id'].toString();
      ref.watch(userDataClass).getProfileData();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,

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
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),

          lineBarsData: [
            // My Bookings (orange)
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

            // My Rentals (blue)
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
    );
  }
}

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
      ref.read(dashboardProvider).fetchDashboard();
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

    // Extract data from dashboard
    final dashboardData = dashboardService.dashboardData;
    final totalEarnings =
        dashboardData['total_earning']?.toString() ?? '\$0.00';
    final totalRating = dashboardData['total_rating']?.toString() ?? '0.0';

    // Extract chart data with safe parsing
    List<double> bookingsData = _parseDynamicList(
      dashboardData['bookings_data'],
      [2, 19, 2, 0, 1, 3],
    );
    List<double> rentalsData = _parseDynamicList(
      dashboardData['rentals_data'],
      [1, 13, 0, 0, 0.5, 2],
    );

    final List<String> chartLabels = (dashboardData['chart_labels'] is List)
        ? (dashboardData['chart_labels'] as List)
              .map((e) => e?.toString() ?? '')
              .toList()
        : [
            "Electrical Box",
            "Violin",
            "Type Writer",
            "Bounce House",
            "Kia Sole",
            "Kayak",
          ];

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
                borderRadius: BorderRadius.circular(30),
              ),
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                Config.imgUrl + ref.watch(userDataClass).userdata['image'],
                semanticLabel: ImgLinks.profileImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: Colors.white, size: 24),
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
            Text(
              "OverAll",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            // ✅ Chart - Container removed, only chart remains
            HomeChart(
              bookingsData: bookingsData,
              rentalsData: rentalsData,
              labels: chartLabels,
            ),
            const SizedBox(height: 26),

            // ✅ Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(width: 15, height: 15, color: Colors.orange),
                    const SizedBox(width: 5),
                    const Text("My Bookings"),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Container(width: 15, height: 15, color: Colors.blue),
                    const SizedBox(width: 5),
                    const Text("My Rentals"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

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
                          totalEarnings,
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
                          "$totalRating ⭐",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

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
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       sum(3, 6, 2);
            //       total = multiply(sum1);
            //     });
            //   },
            //   child: Text("payment"),
            // ),
            // Text("amount: $total"),
            // const SizedBox(height: 20),
          ],
        
        ),
      ),

      bottomNavigationBar: BottomNavBarWidget(currentIndex: 0),
    );
  }
}
