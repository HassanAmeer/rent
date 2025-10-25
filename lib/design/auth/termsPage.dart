import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/settingsData.dart';
import 'package:rent/widgets/dotloader.dart';

class TermsConditionPage extends ConsumerStatefulWidget {
  const TermsConditionPage({super.key});

  @override
  ConsumerState<TermsConditionPage> createState() => _TermsConditionPageState();
}

class _TermsConditionPageState extends ConsumerState<TermsConditionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref.watch(settingsProvider).getDocData(loadingFor: "getdoc");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditioon')),
      body: Center(
        child: ref.watch(settingsProvider).loadingFor == "getdoc"
            ? DotLoader()
            : Transform.scale(
                  scale: 0.9,
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: HtmlWidget( ref.watch(settingsProvider).docData.termsCondition.toString())),
              ),
            ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
