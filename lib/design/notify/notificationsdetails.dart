import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/notifyData.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../constants/api_endpoints.dart';
import '../../widgets/casheimage.dart';

class NotificationsDetails extends ConsumerStatefulWidget {
  final int index;

  const NotificationsDetails({super.key, required this.index});

  @override
  ConsumerState<NotificationsDetails> createState() =>
      _NotificationsDetailsState();
}

class _NotificationsDetailsState extends ConsumerState<NotificationsDetails> {
  @override
  Widget build(BuildContext context) {
    var notify = ref.watch(notifyData).notify[widget.index];
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notify.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            // Text(
            //   "${notify['desc'] ?? 'Description.......'}",
            //   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            // ),
            HtmlWidget(notify.description),

            Divider(),
            ListTile(title: Text("From User")),
            ListTile(
              leading: CacheImageWidget(
                width: 50,
                height: 50,
                isCircle: true,
                radius: 200,
                url: notify.fromUser!.image!,
              ),
              title: Text(notify.fromUser!.name),
              subtitle: Text(notify.fromUser!.email),
            ),
          ],
        ),
      ),
    );
  }
}
