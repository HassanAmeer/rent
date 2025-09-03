import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/message/chatingWithUser.dart';
import 'package:rent/models/allItemsModel.dart';
import 'package:rent/models/chatedmodel.dart';
import 'package:rent/widgets/floatingbutton.dart';

import '../../widgets/casheimage.dart';
// ✅ Edit page import

class Allitemdetailspage extends ConsumerStatefulWidget {
  final AllItemsModel fullData;

  const Allitemdetailspage({super.key, required this.fullData});

  @override
  ConsumerState<Allitemdetailspage> createState() => _AllitemdetailspageState();
}

class _AllitemdetailspageState extends ConsumerState<Allitemdetailspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
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
                    fit: BoxFit.contain,
                    url: Config.imgUrl + widget.fullData.images.first,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "${widget.fullData.title}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              HtmlWidget(widget.fullData.description),

              Divider(),

              ListTile(title: Text("dailyrate: ${widget.fullData.deletedAt}")),
              Divider(),
              ListTile(
                title: Text("weeklyrate: ${widget.fullData.weeklyrate}"),
              ),
              Divider(),
              ListTile(
                title: Text(" monthlyrate: ${widget.fullData.monthlyrate}"),
              ),
              Divider(),
              ListTile(title: Text("created_at: ${widget.fullData.createdAt}")),
              Divider(),
              ListTile(
                title: Text(" updated_at: ${widget.fullData.updatedAt}"),
              ),
              Divider(),
              ListTile(
                title: Text(
                  " availabilityDays: ${widget.fullData.availabilityDays}",
                ),
              ),
              Divider(),

              // Text("$fullData"),
              const ListTile(title: Text("From User")),
              ListTile(
                leading: CacheImageWidget(
                  width: 50,
                  height: 50,
                  isCircle: true,
                  radius: 200,
                  url: Config.imgUrl + widget.fullData.rentalUser.image,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomMessageFAB(
        onPressed: () {
          goto(
            ChatingWithUserPage(
              msgdata: ChatedUser(
                sid: ref.watch(userDataClass).userdata.id,
                rid: widget.fullData.productBy,
                fromuid: User(
                  id: ref.watch(userDataClass).userdata.id,
                  image: ref.watch(userDataClass).userdata.image,
                ),
                touid: User(
                  id: widget.fullData.productBy,
                  image: widget.fullData.rentalUser.image,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
