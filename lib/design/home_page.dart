import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/Auth/homepagechart.dart';
import 'package:rent/apidata/user.dart' show userDataClass;
import 'package:rent/constants/appColors.dart';
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
import '../widgets/home_chart.dart'; // ✅ chart import

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // var sum1 = 0;
  // sum(int a, int b, int c) {
  //   sum1 = a + b + c;
  // }

  // int multiply(int nmbr) {
  //   return nmbr * 5;
  // }

  // var total = 0;
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(imgAssets.logo, width: 100),
        actions: [
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
                borderRadius: BorderRadius.circular(4),
              ),
              width: 35,
              height: 35,
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                Config.apiUrl + ref.watch(userDataClass).userdata['image'] ??
                    '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, color: Colors.white);
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NotificationPage(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Chart Box
            Container(
              padding: const EdgeInsets.all(8),
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Expanded(child: HomeChart()),
                  SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                        const Text(
                          "\$1234.00",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Rating",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "4.5 ⭐",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
