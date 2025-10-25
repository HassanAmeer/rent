import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/constants/screensizes.dart';

import '../../constants/api_endpoints.dart';
import '../../constants/images.dart';
import '../../models/rent_out_model.dart';
import '../../widgets/casheimage.dart';

class RentOutDetailsPage extends ConsumerStatefulWidget {
  BookingModel data;
  RentOutDetailsPage({super.key, required this.data});

  @override
  ConsumerState<RentOutDetailsPage> createState() => _RentOutDetailsPageState();
}

class _RentOutDetailsPageState extends ConsumerState<RentOutDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("  Rent Out Details")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(Icons.chat_outlined, size: 22, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CacheImageWidget(
                    width: double.infinity,
                    height: ScreenSize.height * 0.4,
                    isCircle: false,
                    radius: 0,
                    url: widget.data.productImages.first,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                widget.data.productTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Divider(),

              ListTile(title: Text("daily rate: ${widget.data.dailyRate}")),
              Divider(),
              ListTile(title: Text("weekly rate: ${widget.data.weeklyRate}")),
              Divider(),
              ListTile(
                title: Text(" monthly rate: ${widget.data.monthlyRate}"),
              ),
              Divider(),
              ListTile(
                title: Text("created_at: ${widget.data.createdAt ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text(" Availability Days: ${widget.data.availability}"),
              ),
              Divider(),

              ListTile(title: Text("From User")),

              ListTile(
                leading: CacheImageWidget(
                  width: 50,
                  height: 50,
                  isCircle: true,
                  radius: 200,
                  url: widget.data.orderByUser!.fullImageUrl,
                ),
                title: Text(widget.data.orderByUser!.name),
                subtitle: Text(widget.data.orderByUser!.email),
              ),

              //
            ],
          ),
        ),
      ),
    );
  }
}
