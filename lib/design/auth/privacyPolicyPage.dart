import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/settingsData.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../constants/appColors.dart';

class PrivacyPolicyPage extends ConsumerStatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  ConsumerState<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends ConsumerState<PrivacyPolicyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref.watch(settingsProvider).getDocData(loadingFor: "getdoc");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, AppColors.mainColor.shade100],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.transparent,

          title: const Text('Privacy Policy'),
        ),
        body: Center(
          child: ref.watch(settingsProvider).loadingFor == "getdoc"
              ? DotLoader()
              : Transform.scale(
                  scale: 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: HtmlWidget(
                        ref
                            .watch(settingsProvider)
                            .docData
                            .privacyPolicy
                            .toString(),
                      ),
                    ),
                  ),
                ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
