import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/listing/ListingDetailPage.dart';
import 'package:rent/design/listing/add_new_listing_page.dart';
import 'package:rent/widgets/btmnavbar.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/searchfield.dart';
import '../../apidata/listingapi.dart';
import '../../apidata/user.dart';
import '../home_page.dart';

class ListingPage extends ConsumerStatefulWidget {
  const ListingPage({super.key});

  @override
  ConsumerState<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends ConsumerState<ListingPage> {
  var searchfieldcontroller = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref
          .watch(listingDataProvider)
          .fetchMyItems(
            uid: ref.watch(userDataClass).userData["id"].toString(),
            search: "",
            loadingfor: "123",
          );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listingProvider = ref.watch(listingDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Listings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              /// Search Bar
              SearchFeildWidget(
                searchFieldController: searchfieldcontroller,
                hint: "Search Listings...",
                onSearchIconTap: () {
                  if (searchfieldcontroller.text.isEmpty) {
                    toast("Write Someting");
                    return;
                  }
                  ref
                      .watch(listingDataProvider)
                      .fetchMyItems(
                        uid: ref.watch(userDataClass).userData["id"].toString(),
                        search: searchfieldcontroller.text,
                        loadingfor: "123",
                      );
                },
              ),
              SizedBox(height: 10),
              ref.watch(listingDataProvider).loadingfor == "123"
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 250),
                        child: DotLoader(),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.1,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 10,
                          ),
                      shrinkWrap: true,
                      controller: ScrollController(),
                      itemCount: listingProvider.listings.length,
                      itemBuilder: (context, index) {
                        final item = listingProvider.listings[index];
                        return GestureDetector(
                          onTap: () {
                            goto(ListingDetailPage(fullData: item));
                          },
                          child: ListingBox(
                            ref: ref, // ✅ ref pass kar diya constructor se
                            id: item['id'].toString(),
                            productBy: item["productBy"],
                            title: item['title'] ?? 'No Name',
                            imageUrl:
                                Config.imgUrl +
                                (item['images'][0] ?? ImgLinks.product),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),

      /// Floating Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewListingPage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      /// Bottom Navigation
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 1),
    );
  }
}

class ListingBox extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  final WidgetRef ref;
  var productBy; // ✅ ref constructor me receive karenge

  ListingBox({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.id,
    required this.ref,
    var productBy, // ✅ required banaya
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: ScreenSize.height*0.1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image container with expanded height
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: CacheImageWidget(
                  url: imageUrl,
                  isCircle: false,
                  width: ScreenSize.width * 0.46,
                  height: ScreenSize.height * 0.16,
                ),
              ),
              Positioned(
                top: 5,
                right: 5,

                child:
                    ref.read(listingDataProvider).loadingfor.toString() ==
                        id.toString()
                    ? CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.black,
                        child: DotLoader(showDots: 1),
                      )
                    : GestureDetector(
                        onTap: () {
                          // Show confirm
                          //Dation dialog

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text(
                                'Delete Listing',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                'Are you sure you want to delete this listing?',
                                style: TextStyle(color: Colors.grey),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Cancel',

                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // ✅ delete using ref

                                    ref
                                        .read(listingDataProvider)
                                        .deleteNotifications(
                                          notificationId: id,
                                          uid: ref
                                              .watch(userDataClass)
                                              .userData["id"]
                                              .toString(),
                                          loadingfor: id,
                                        );
                                    Navigator.pop(context);
                                  },
                                  child:
                                      const Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )
                                          .animate(
                                            onPlay: (controller) => controller
                                                .repeat(reverse: true),
                                          )
                                          .shimmer(color: Colors.red.shade200),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              238,
                              236,
                              236,
                            ).withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Color.fromARGB(255, 193, 16, 4),
                          ),
                        ),
                      ),
              ),
            ],
          ),

          // Text container with reduced height
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
