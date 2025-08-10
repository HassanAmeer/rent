import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/favrtapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/fvart/allitems.dart';
import 'package:rent/fvart/favdetails.dart';
import 'package:rent/widgets/casheimage.dart';

import '../constants/data.dart';

class Favourite extends ConsumerStatefulWidget {
  const Favourite({super.key});

  @override
  ConsumerState<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends ConsumerState<Favourite> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  Future<void> _loadFavorites() async {
    final userId = ref.read(userDataClass).userdata["id"].toString();
    await ref.read(favrtdata).favoritems(uid: userId);
  }

  @override
  Widget build(BuildContext context) {
    final favrtProvider = ref.watch(favrtdata);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadFavorites,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                      const Icon(Icons.search, color: Colors.black),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search How to & more',
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.8),
                        child: const Text(
                          'Go',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Favorites Grid
              if (favrtProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (favrtProvider.favrt.isEmpty)
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
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: favrtProvider.favrt.length,
                    itemBuilder: (context, index) {
                      final item = favrtProvider.favrt[index];
                      // return Text(item.toString()); // Example usage of item
                      return GestureDetector(
                        onTap: () {
                          goto(FavDetailsPage(fullData: item['products']));
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
                                    height: 150,
                                    width: 165,
                                    url:
                                        Config.imgUrl +
                                        item['products']['images'][0],
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.bookmark,
                                        color: Colors.white,
                                        size: 28,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(1, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              item['products']['title'],
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

      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 8.0, bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              goto(AllItemsPage());
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
