import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/help&supportapi.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends ConsumerStatefulWidget {
  const Help({super.key});

  @override
  ConsumerState<Help> createState() => _HelpState();
}

class _HelpState extends ConsumerState<Help> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref.read(SupportProvider).contectus(loadingFor: "help");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,

        title: Text(
          "Help and support",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 27),

          // Center(
          //   child: Text(
          //     "Contact information :",
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          //   ),
          // ),
          // SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '''If you have any questions or need assistance, feel free to reach out to us. We’re here to help! ''',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ),

          SizedBox(height: 20),

          ListTile(
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.only(left: 20),
            title: Text(
              "Contect us",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
          ref.watch(SupportProvider).loadingFor == "help"
              ? const Center(child: DotLoader())
              : ref.watch(SupportProvider).settings == null
              ? Center(child: Text("Settings not available"))
              : ListTile(
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.only(left: 20),
                  title: Text(
                    "Email:",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map(
                            (MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                          )
                          .join('&');
                    }

                    // ···
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: ref.watch(SupportProvider).settings!.displayEmail,
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Hey: welcome to the Local rent',
                      }),
                    );

                    launchUrl(emailLaunchUri);
                  },

                  subtitle: Text(
                    ref.watch(SupportProvider).settings!.displayEmail,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
          SizedBox(height: 10),
          ListTile(
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.only(left: 20),
            title: Text(
              "Hours:",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text(
              ref.watch(SupportProvider).settings?.supportHours ??
                  '09:00 AM - 06:00 PM PKT (Monday to Friday)',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
