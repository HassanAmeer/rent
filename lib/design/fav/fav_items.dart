import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/design/all%20items/allitems.dart';
import 'package:rent/design/fav/favdetails.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../apidata/allitemsapi.dart';
import '../../apidata/favrtapi.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/images.dart';
import '../../models/favorite_model.dart';
import '../../widgets/listings_widgets/items_box_widget.dart';

class Favourite extends ConsumerStatefulWidget {
  const Favourite({super.key});

  @override
  ConsumerState<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends ConsumerState<Favourite> {
  var searchcontrollers = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  Future<void> _loadFavorites() async {
    final userId = ref.read(userDataClass).userId;
    await ref
        .read(favProvider)
        .getAllFavItems(loadingFor: "favorItems", uid: userId, search: "");
  }

  @override
  Widget build(BuildContext context) {
    final favrtProvider = ref.watch(favProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final userId = ref.read(userDataClass).userId;
          await ref
              .read(favProvider)
              .getAllFavItems(
                loadingFor: "refresh",
                uid: userId,
                search: "",
                refresh: true,
              );
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              favrtProvider.loadingFor == "refresh"
                  ? Container(
                      height: 60,
                      child: QuickTikTokLoader(
                        progressColor: AppColors.mainColor,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ).animate().fadeIn(duration: Duration(milliseconds: 300))
                  : SizedBox.shrink(),

              const SizedBox(height: 8),

              // Search Bar
              Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchcontrollers,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                  .read(favProvider)
                                  .getAllFavItems(
                                    refresh: true,
                                    loadingFor: "refresh",
                                    uid: ref.watch(userDataClass).userId,
                                    search: searchcontrollers.text,
                                  );
                            },
                            icon: Icon(
                              Icons.search,
                              color: AppColors.mainColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          hintText: 'Search favorites & more...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 300),
                    duration: Duration(milliseconds: 800),
                  )
                  .slideY(begin: -0.1),
              // Favorites Grid
              if (favrtProvider.loadingFor == "favorItems")
                Center(
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mainColor.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DotLoader(),
                            SizedBox(height: 16),
                            Text(
                              "Loading favorites...",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: Duration(milliseconds: 500))
                    .scale()
              else if (favrtProvider.favouriteItems.isEmpty)
                Center(
                      child: Container(
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mainColor.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 80,
                              color: AppColors.mainColor,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No Favorites Found",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Your favorite items will appear here",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 800),
                    )
                    .scale()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child:
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              ScreenSize.isTablet || ScreenSize.isDesktop
                              ? 3
                              : 2,
                          crossAxisSpacing:
                              ScreenSize.isTablet || ScreenSize.isDesktop
                              ? 20
                              : 16,
                          mainAxisSpacing:
                              ScreenSize.isTablet || ScreenSize.isDesktop
                              ? 20
                              : 16,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: favrtProvider.favouriteItems.length,
                        itemBuilder: (context, index) {
                          final item = favrtProvider.favouriteItems[index];

                          return ListingBox(
                                id: item.id.toString(),
                                title: item.displayTitle,
                                showFav: true,
                                onFavTap: () {
                                  ref
                                      .read(favProvider)
                                      .togglefavrt(
                                        uid: ref.watch(userDataClass).userId,
                                        itemId: item.itemId.toString(),
                                        loadingFor: item.id.toString(),
                                      );
                                },
                                isFavLoading:
                                    favrtProvider.loadingFor ==
                                    item.id.toString(),
                                isFavFilled: true,
                                imageUrl: item.itemImages.first,
                                onTap: () => goto(FavDetailsPage(index: index)),
                              )
                              .animate()
                              .fadeIn(
                                delay: Duration(milliseconds: index * 100),
                                duration: 0.2.seconds,
                              )
                              .slideY(begin: 0.2);
                        },
                      ).animate().fadeIn(
                        delay: Duration(milliseconds: 500),
                        duration: Duration(milliseconds: 800),
                      ),
                ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child:
            FloatingActionButton(
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              onPressed: () {
                goto(AllItemsPage());
              },
              child: const Icon(Icons.add),
            ).animate().scale(
              delay: Duration(milliseconds: 500),
              duration: Duration(milliseconds: 500),
            ),
      ),
    );
  }
}
