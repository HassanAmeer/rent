import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/design/listing/ListingDetailPage.dart';
import 'package:rent/design/listing/add_new_listing_page.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import 'package:rent/widgets/searchfield.dart';
import '../../apidata/listingapi.dart';
import '../../apidata/user.dart';
import '../../widgets/delete_alert_box.dart';
import '../../widgets/lsitings_widgets/items_box_widget.dart';

class ListingPage extends ConsumerStatefulWidget {
  const ListingPage({super.key});

  @override
  ConsumerState<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends ConsumerState<ListingPage> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch(''));
    _searchCtrl.addListener(() {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _fetch(_searchCtrl.text.trim());
      });
    });
  }

  void _fetch(String query, {bool refresh = false, String loadingFor = ""}) {
    final uid = ref.read(userDataClass).userData["id"].toString();
    ref
        .read(listingDataProvider)
        .fetchMyItems(
          uid: uid,
          search: query,
          refresh: refresh,
          loadingfor: loadingFor.isNotEmpty
              ? loadingFor
              : refresh
              ? "refresh"
              : "getlistings",
        );
  }

  Future<void> _refresh() async =>
      _fetch(_searchCtrl.text.trim(), refresh: true, loadingFor: "refresh");

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = ref.watch(listingDataProvider);
    final isInit = prov.loadingfor == "getlistings";
    final isRefresh = prov.loadingfor == "refresh";

    // responsive cross-axis count
    final width = MediaQuery.of(context).size.width;
    final crossCount = width > 1200
        ? 4
        : width > 800
        ? 3
        : 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarColor: Colors.transparent,
        //   statusBarIconBrightness: Brightness.dark,
        // ),
        flexibleSpace: prov.loadingfor == "refresh"
            ? QuickTikTokLoader(
                height: 5,
                progressColor: AppColors.mainColor,
                backgroundColor: Colors.white,
              ).animate().fadeIn(duration: const Duration(milliseconds: 300))
            : SizedBox.shrink(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'My Listings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        // actions: [
        //   PopupMenuButton<String>(
        //     icon: const Icon(Icons.more_vert),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     color: Colors.black54,
        //     itemBuilder: (_) => [
        //       PopupMenuItem(
        //         value: 'refresh',
        //         child: Row(
        //           children: [
        //             Icon(
        //               Icons.refresh,
        //               color: isRefresh ? AppColors.mainColor : Colors.white,
        //             ).animate().rotate(duration: isRefresh ? 800.ms : 0.ms),
        //             const SizedBox(width: 8),
        //             const Text(
        //               'Refresh',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //     onSelected: (_) => _refresh(),
        //   ),
        // ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFB2EBF2)], // cyan[200]
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: AppColors.mainColor,
            child: CustomScrollView(
              controller: _scrollCtrl,
              slivers: [
                // ---------- SEARCH ----------
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    child: SearchFeildWidget(
                      searchFieldController: _searchCtrl,
                      hint: "Search listings…",
                      onSearchIconTap: () => _fetch(_searchCtrl.text.trim()),
                    ),
                  ),
                ),

                // ---------- LOADING / EMPTY ----------
                if (isInit)
                  const SliverFillRemaining(child: Center(child: DotLoader()))
                else if (prov.listings.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.list_alt,
                            size: 72,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No listings yet",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _refresh,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Refresh"),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // ---------- GRID ----------
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossCount,
                        mainAxisSpacing: ScreenSize.width * 0.03,
                        crossAxisSpacing: ScreenSize.width * 0.03,
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate((ctx, i) {
                        final item = prov.listings[i];
                        final deleting = prov.loadingfor == item.id.toString();

                        return ListingBox(
                              id: item.id.toString(),
                              title: item.displayTitle,
                              imageUrl: item.images.first,
                              showDelete: true,
                              isDeleteLoading: deleting,
                              onTap: () => goto(ListingDetailPage(index: i)),
                              onDeleteTap: () {
                                alertBoxDelete(
                                  context,
                                  onDeleteTap: () {
                                    final uid = ref
                                        .read(userDataClass)
                                        .userData["id"]
                                        .toString();
                                    ref
                                        .read(listingDataProvider)
                                        .deleteItemById(
                                          itemId: item.id.toString(),
                                          uid: uid,
                                          loadingfor: item.id.toString(),
                                        );
                                  },
                                );
                              },
                            )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: i * 100),
                              duration: 0.2.seconds,
                            )
                            .slideY(begin: 0.2);
                      }, childCount: prov.listings.length),
                    ),
                  ),

                // ---------- REFRESH BAR ----------
                if (isRefresh)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: QuickTikTokLoader(
                        progressColor: AppColors.mainColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      // ---------- FAB ----------
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        elevation: 8,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddNewListingPage()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 150.ms),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
