import 'package:flutter/material.dart';
import 'package:rent/constants/scrensizes.dart';
import 'booking_edit_page.dart';
import 'add_new_booking_page.dart';

class MyBookingPage extends StatelessWidget {
  const MyBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          "My Bookings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search bar just below AppBar (with grey background)
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                hintText: "Search How to & More",
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
          // Bookings grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: bookingsData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Mobile 2 columns
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) =>
                  _bookingCard(context, bookingsData[index]),
            ),
          ),
        ],
      ),

      // Floating Action Button for Add New Booking
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Navigate to Add New Booking Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewBookingPage()),
          );
        },
      ),

      // bottomNavigationBar: BottomNavBarWidget(currentIndex: 2),
    );
  }

  Widget _bookingCard(BuildContext context, Map<String, dynamic> booking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.14),
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left-side icons column
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconCircleButton(Icons.edit, Colors.white, () {
                      // Navigate to Edit Booking Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBookingPage(),
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                    _iconCircleButton(Icons.delete, Colors.red, () {
                      // Delete logic here
                      // You can add your delete confirmation/dialog
                    }),
                  ],
                ),
              ),
              // Main content (image and texts, centered)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          booking["imageUrl"],
                          height: 85,
                          width: ScreenSize.width * .6,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: ScreenSize.height * 0.5,
                                width: ScreenSize.width * 0.5,

                                color: Colors.grey[300],
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Request By: ${booking["requestBy"]}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Right-top Status Label
          Positioned(right: 8, top: 8, child: _statusLabel(booking["status"])),
        ],
      ),
    );
  }

  Widget _iconCircleButton(
    IconData icon,
    Color iconColor,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.black,
        child: Icon(icon, color: iconColor, size: 16.5),
      ),
    );
  }

  Widget _statusLabel(String? status) {
    Color bgColor = Colors.orange;
    if (status == "Rent Out") {
      bgColor = Colors.blue;
    } else if (status == "Closed") {
      bgColor = Colors.green;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// Demo data as per your requirements
final List<Map<String, dynamic>> bookingsData = [
  {
    "requestBy": "John David",
    "name": "ultrapod",
    "imageUrl": "https://cdn-icons-png.flaticon.com/128/2674/2674486.png",

    "status": "Rent Out",
  },
  {
    "requestBy": "John David",
    "name": "ultrapod",
    "imageUrl": "https://cdn-icons-png.flaticon.com/128/2674/2674486.png",
    "status": "Pending",
  },
  {
    "requestBy": "John David",
    "name": "q32",
    "imageUrl": "https://cdn-icons-png.flaticon.com/128/2674/2674486.png",
    "status": "Rent Out",
  },
  {
    "requestBy": "John David",
    "name": "q32",
    "imageUrl": "https://cdn-icons-png.flaticon.com/128/2674/2674486.png",
    "status": "Closed",
  },
  {
    "requestBy": "John David",
    "name": "q32",
    "imageUrl": "https://cdn-icons-png.flaticon.com/128/2674/2674486.png",
    "status": "Pending",
  },
  {
    "requestBy": "John David",
    "name": "q32",
    "imageUrl": "https://cdn-icons-png.flaticon.com/128/2674/2674486.png",
    "status": "Pending",
  },
  {
    "requestBy": "John David",
    "name": "q32",
    "imageUrl": "https://cdn-icons-png.flaticon.com/128/2674/2674486.png",
    "status": "Pending",
  },
];
