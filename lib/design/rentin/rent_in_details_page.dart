import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:rent/apidata/myrentalapi.dart' show rentalDataProvider;
import 'package:rent/constants/images.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/imageview.dart';

import '../../constants/api_endpoints.dart';
import '../../constants/screensizes.dart';
import '../../models/rent_in_model.dart';

class RentInDetailsPage extends ConsumerStatefulWidget {
  final RentInModel renting;
  const RentInDetailsPage({super.key, required this.renting});

  @override
  ConsumerState<RentInDetailsPage> createState() => _RentInDetailsPageState();
}

class _RentInDetailsPageState extends ConsumerState<RentInDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent In Details"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.chat_outlined),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 2, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(1, 1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.renting.deliverd.toString()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(widget.renting.deliverd.toString()),
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusText(widget.renting.deliverd.toString()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price   ", style: TextStyle(color: Colors.grey)),
                  Text(
                    "\$${widget.renting.totalPriceByUser}",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider.builder(
              itemCount: widget.renting.productImage.length,
              itemBuilder: (context, index, realIndex) {
                final imageUrl = widget.renting.productImage[index];
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
                autoPlay: widget.renting.productImage.length > 1,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: widget.renting.productImage.length > 1,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status Row
                  // const SizedBox(height: 5),
                  Text(
                    widget.renting.productTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Description Section
                  if (widget.renting.productDesc.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(widget.renting.productDesc),
                    const SizedBox(height: 24),
                  ],

                  // Rental Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rental Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          "Daily Rate",
                          "\$${widget.renting.dailyrate ?? '0'}",
                        ),
                        _buildInfoRow(
                          "Weekly Rate",
                          "\$${widget.renting.weeklyrate ?? '0'}",
                        ),
                        _buildInfoRow(
                          "Monthly Rate",
                          "\$${widget.renting.monthlyrate ?? '0'}",
                        ),

                        const SizedBox(height: 16),

                        if (widget.renting.availability.isNotEmpty)
                          _buildInfoRow(
                            "Availability",
                            widget.renting.availability,
                          ),
                        SizedBox(height: 20),
                        Divider(color: Colors.grey.shade400),
                        if (widget.renting.productPickupDate != null)
                          _buildInfoRow(
                            "Pickup Date",
                            widget.renting.userCanPickupInDateRange
                                    ?.toString() ??
                                'N/A',
                          ),

                        // Divider(color: Colors.green.shade50),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // User Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Listing By",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: CacheImageWidget(
                                width: 50,
                                height: 40,
                                isCircle: true,
                                radius: 0,
                                url: widget.renting.productby!.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            widget.renting.productby?.name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            widget.renting.productby?.email ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Divider(),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          "Listing Date",
                          _formatDate(widget.renting.createdAt),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get status color
  Color _getStatusColor(String? status) {
    return status == "1" ? Colors.green : Colors.orange;
  }

  // Helper method to get status icon
  IconData _getStatusIcon(String? status) {
    return status == "1" ? Icons.check_circle : Icons.history;
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
