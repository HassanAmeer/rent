import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/goto.dart';

import '../../constants/images.dart';
import '../../widgets/casheimage.dart';

class Bookindetails extends ConsumerStatefulWidget {
  var data;
  Bookindetails({super.key, this.data});

  @override
  ConsumerState<Bookindetails> createState() => _BookindetailsState();
}

class _BookindetailsState extends ConsumerState<Bookindetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("${widget.data}"),
              Stack(
                children: [
                  CacheImageWidget(
                    width: 300,
                    height: 150,
                    isCircle: false,
                    radius: 0,
                    url:
                        Config.imgUrl +
                            jsonDecode(widget.data['productImage'])[0] ??
                        ImgLinks.profileImage,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "${widget.data['productTitle'] ?? 'Title.......'}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Divider(),

              ListTile(
                title: Text("dailyrate: ${widget.data['dailyrate'] ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text("weeklyrate: ${widget.data['weeklyrate'] ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text(
                  " monthlyrate: ${widget.data['monthlyrate'] ?? '0'}",
                ),
              ),
              Divider(),
              ListTile(
                title: Text("created_at: ${widget.data['created_at'] ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text(
                  " updated_at: ${widget.data[' updated_at'] ?? '0'}",
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  " availabilityDays: ${widget.data['availabilityDays'] ?? '0'}",
                ),
              ),
              Divider(),

              ListTile(title: Text("From User")),

              ListTile(
                leading: CacheImageWidget(
                  width: 50,
                  height: 50,
                  isCircle: true,
                  radius: 200,
                  url:
                      Config.imgUrl + widget.data["orderby"]['image'][0] ??
                      ImgLinks.profileImage,
                ),
                title: Text(widget.data['orderby']['name'] ?? 'Unknown'),
                subtitle: Text(widget.data['orderby']['email'] ?? 'Unknown'),
              ),

              //
            ],
          ),
        ),
      ),
    );
  }
}
