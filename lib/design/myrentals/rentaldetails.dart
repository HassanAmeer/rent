import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/myrentalapi.dart' show rentalDataProvider;
import 'package:rent/constants/data.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

class Rentaldetails extends ConsumerStatefulWidget {
  final dynamic renting;
  const Rentaldetails({super.key, this.renting});

  @override
  ConsumerState<Rentaldetails> createState() => _RentaldetailsState();
}

class _RentaldetailsState extends ConsumerState<Rentaldetails> {
  @override
  void initState() {
    super.initState();
    // No need to fetch additional data - use the data passed from previous page
  }

  @override
  Widget build(BuildContext context) {
    final rentalData = widget.renting ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text("Rental Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("${widget.renting}"),
              Stack(
                children: [
                  CacheImageWidget(
                    width: 300,
                    height: 150,
                    isCircle: false,
                    radius: 0,
                    url: _getImageUrl(rentalData),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                rentalData['productTitle']?.toString() ?? 'Title.......',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Status Card
              Card(
                color: _getStatusColor(rentalData['deliverd']?.toString()),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(rentalData['deliverd']?.toString()),
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getStatusText(rentalData['deliverd']?.toString()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Rental Information
              _buildInfoCard("Rental Information", [
                _buildInfoRow(
                  "Daily Rate",
                  "\$${rentalData['dailyrate'] ?? '0'}",
                ),
                _buildInfoRow(
                  "Weekly Rate",
                  "\$${rentalData['weeklyrate'] ?? '0'}",
                ),
                _buildInfoRow(
                  "Monthly Rate",
                  "\$${rentalData['monthlyrate'] ?? '0'}",
                ),
                _buildInfoRow("Created", _formatDate(rentalData['created_at'])),
                _buildInfoRow("Updated", _formatDate(rentalData['updated_at'])),
                if (rentalData['availabilityDays'] != null)
                  _buildInfoRow(
                    "Availability",
                    rentalData['availabilityDays'].toString(),
                  ),
                if (rentalData['productPickupDate'] != null)
                  _buildInfoRow(
                    "Pickup Date",
                    rentalData['productPickupDate'].toString(),
                  ),
                if (rentalData['totalPriceByUser'] != null)
                  _buildInfoRow(
                    "Total Price",
                    "\$${rentalData['totalPriceByUser']}",
                  ),
              ]),

              const SizedBox(height: 16),

              // User Information
              _buildInfoCard("Rented By", [
                ListTile(
                  leading: CacheImageWidget(
                    width: 50,
                    height: 50,
                    isCircle: true,
                    radius: 200,
                    url: _getUserImageUrl(rentalData),
                  ),
                  title: Text(_getUserName(rentalData)),
                  subtitle: Text(_getUserEmail(rentalData)),
                  contentPadding: EdgeInsets.zero,
                ),
              ]),

              //
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to safely get image URL
  String _getImageUrl(dynamic rental) {
    try {
      if (rental['productImage'] != null) {
        var images = jsonDecode(rental['productImage']);
        if (images is List && images.isNotEmpty) {
          return Config.imgUrl + images[0];
        }
      }
    } catch (e) {
      print("Error parsing image: $e");
    }
    return ImgLinks.product;
  }

  // Helper method to get user image URL
  String _getUserImageUrl(dynamic rental) {
    try {
      if (rental['orderby'] != null && rental['orderby']['image'] != null) {
        return Config.imgUrl + rental['orderby']['image'];
      }
      if (rental['productby'] != null && rental['productby']['image'] != null) {
        return Config.imgUrl + rental['productby']['image'];
      }
    } catch (e) {
      print("Error getting user image: $e");
    }
    return ImgLinks.profileImage;
  }

  // Helper method to get user name
  String _getUserName(dynamic rental) {
    try {
      if (rental['orderby'] != null && rental['orderby']['name'] != null) {
        return rental['orderby']['name'].toString();
      }
      if (rental['productby'] != null && rental['productby']['name'] != null) {
        return rental['productby']['name'].toString();
      }
    } catch (e) {
      print("Error getting user name: $e");
    }
    return "Unknown User";
  }

  // Helper method to get user email
  String _getUserEmail(dynamic rental) {
    try {
      if (rental['orderby'] != null && rental['orderby']['email'] != null) {
        return rental['orderby']['email'].toString();
      }
      if (rental['productby'] != null && rental['productby']['email'] != null) {
        return rental['productby']['email'].toString();
      }
    } catch (e) {
      print("Error getting user email: $e");
    }
    return "Unknown Email";
  }

  // Helper method to get status color
  Color _getStatusColor(String? status) {
    return status == "1" ? Colors.green : Colors.orange;
  }

  // Helper method to get status icon
  IconData _getStatusIcon(String? status) {
    return status == "1" ? Icons.check_circle : Icons.pending;
  }

  // Helper method to get status text
  String _getStatusText(String? status) {
    return status == "1" ? "Delivered" : "Not Delivered";
  }

  // Helper method to format date
  String _formatDate(dynamic date) {
    if (date == null) return 'Not specified';
    try {
      DateTime parsedDate = DateTime.parse(date.toString());
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return date.toString();
    }
  }

  // Helper method to build info card
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // Helper method to build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Method to toggle rental status
  // void _toggleStatus(dynamic rental) {
  //   if (rental['id'] == null) return;

  //   final currentStatus = rental['deliverd']?.toString() ?? "0";
  //   final newStatus = currentStatus == "1" ? "0" : "1";

  //   ref
  //       .read(rentalDataProvider)
  //       .updateRentalStatus(
  //         rentalId: rental['id'].toString(),
  //         status: newStatus,
  //         loadingFor: "updateStatus",
  //       );
}
