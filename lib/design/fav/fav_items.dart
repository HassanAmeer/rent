import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/design/all%20items/allitems.dart';
import 'package:rent/design/fav/fav_details.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../apidata/favrtapi.dart';
import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/images.dart';
import '../../models/favorite_model.dart';

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
        .read(favrtdata)
        .favorItems(loadingFor: "favorItems", uid: userId, search: "");
  }

  @override
  Widget build(BuildContext context) {
    final favrtProvider = ref.watch(favrtdata);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final userId = ref.read(userDataClass).userId;
          await ref
              .read(favrtdata)
              .favorItems(
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
                  ? QuickTikTokLoader(
                      progressColor: Colors.black,
                      backgroundColor: Colors.grey,
                    )
                  : SizedBox.shrink(),

              const SizedBox(height: 3),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: searchcontrollers,

                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                ref
                                    .read(favrtdata)
                                    .favorItems(
                                      refresh: true,
                                      loadingFor: "refresh",
                                      uid: ref.watch(userDataClass).userId,
                                      search: searchcontrollers.text,
                                    );
                              },

                              child: Icon(Icons.search),
                            ),
                            hintText: 'Search How to & more',
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Column(
              //   children: favrtProvider.favrt
              //       .map(
              //         (e) => Text("$e _____________________________________"),
              //       )
              //       .toList(),
              // ),

              // Favorites Grid
              if (favrtProvider.loadingFor == "favorItems")
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 260),
                    child: DotLoader(),
                  ),
                )
              else if (favrtProvider.favouriteItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("No favorites found"),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                    itemCount: favrtProvider.favouriteItems.length,
                    itemBuilder: (context, index) {
                      final item = favrtProvider.favouriteItems[index];
                      // return Text(item.displayTitle.toString());
                      return GestureDetector(
                        onTap: () {
                          goto(FavDetailsPage(item: item));
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.cyan.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyan.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  CacheImageWidget(
                                    isCircle: false,
                                    height: 130,
                                    width: 165,
                                    url: item.itemImages.first,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child:
                                        ref.watch(favrtdata).loadingFor ==
                                            item.id.toString()
                                        ? DotLoader(showDots: 1)
                                        // ? Icon(Icons.h_mobiledata_outlined)
                                        : InkWell(
                                            onTap: () {
                                              ref
                                                  .watch(favrtdata)
                                                  .addfavrt(
                                                    uid: ref
                                                        .watch(userDataClass)
                                                        .userId,
                                                    itemId: item.itemId
                                                        .toString(),
                                                    loadingFor: item.id
                                                        .toString(),
                                                  );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Icon(
                                                Icons.bookmark,
                                                color: Colors.white,
                                                size: 28,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 4,
                                                    offset: const Offset(1, 2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              item.displayTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            goto(AllItemsPage());
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
