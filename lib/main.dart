import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/images.dart';
import 'apidata/categoryapi.dart';
import 'apidata/user.dart';
import 'design/home_page.dart';
import 'design/listing/listing_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

GlobalKey<NavigatorState> contextKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent',
      navigatorKey: contextKey,
      theme: ThemeData(
        // ✅ Tap/Click ripple colors (Cyan theme)
        splashColor: AppColors.mainColor.withOpacity(0.3),
        highlightColor: AppColors.mainColor.withOpacity(0.1),
        hoverColor: AppColors.mainColor.withOpacity(0.05),

        // ✅ Dialog theme (rounded corners)
        dialogTheme: const DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),

        // ✅ Text button theme (for dialog buttons - Cyan)
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.mainColor,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        // ✅ Elevated button theme (Cyan background)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.btnBgColor,
          foregroundColor: AppColors.btnIconColor,
          splashColor: AppColors.mainColor.withOpacity(0.3),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: AppColors.mainColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          ),
        ),
        primarySwatch: AppColors.mainColor,
        scaffoldBackgroundColor: AppColors.scaffoldBgColor,
        appBarTheme: AppBarTheme(backgroundColor: AppColors.mainColor),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  syncFirstF() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(userDataClass).checkAlreadyhaveLogin();
      // goto(LoginPage(), canBack: false, delay: 3000);
      ref.read(categoryProvider).fetchCategories(loadingFor: "category");
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.mainColor),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            var isPhone = constraints.maxWidth <= 424;
            var isTablet =
                // var desktop = constraints.maxWidth >= 1024;
                (constraints.maxWidth >= 424 && constraints.maxWidth <= 1024);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child:
                      SizedBox(
                            width: isPhone
                                ? w * 0.7
                                : isTablet
                                ? w * 0.4
                                : w * 0.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                ImgAssets.logo,
                                // color: AppColor.primary.withOpacity(0.1),
                              ),
                            ),
                          )
                          .animate(
                            // onPlay: (controller) => controller.repeat()
                          )
                          .scale(
                            begin: Offset(0, -1),
                            duration: const Duration(milliseconds: 100),
                            // delay: const Duration(milliseconds: 2700)
                          )
                          .shimmer(
                            color: Colors.cyan,
                            duration: 1000.milliseconds,
                          ),
                ),

                // Text("hjkl")
                // SizedBox(height: h * 0.03),
                // Text(
                //       'Rhe Local Rent!'.toUpperCase(),
                //       textAlign: TextAlign.center,
                //       style: GoogleFonts.orbitron(
                //         textStyle: Theme.of(context).textTheme.headlineLarge!
                //             .copyWith(
                //               color: AppColors.mainColor,
                //               letterSpacing: 1,
                //               shadows: [
                //                 BoxShadow(
                //                   color: AppColors.mainColor,
                //                   offset: const Offset(1, 1),
                //                   blurRadius: 1,
                //                 ),
                //               ],
                //             ),
                //       ),
                //     )
                //     .animate(onPlay: (controller) => controller.repeat())
                //     .shimmer(
                //       color: AppColors.mainColor,
                //       duration: const Duration(milliseconds: 1500),
                //       delay: const Duration(milliseconds: 500),
                //     ),
              ],
            );
          },
        ),
      ),
    );
  }
}



// <?php
// // Allow all origins and set response to JSON
// header("Access-Control-Allow-Origin: *");
// header("Content-Type: application/json; charset=UTF-8");
// header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
// header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// // Database configuration (UPDATE these values for your hosting)
// $host = "your_host";         // e.g., sql123.host.com
// $user = "your_username";     // e.g., db_user
// $password = "your_password"; // e.g., password123
// $database = "your_database"; // e.g., rent_app

// $conn = new mysqli($host, $user, $password, $database);
// if ($conn->connect_error) {
//     http_response_code(500);
//     echo json_encode(["success" => false, "message" => "Database connection failed"]);
//     exit();
// }

// // Get 'action' from GET or POST
// $action = $_REQUEST['action'] ?? '';

// // SWITCH BASED ON ACTION
// switch ($action) {

//     // ✅ GET ALL LISTINGS
//     case 'get_all':
//         $result = $conn->query("SELECT * FROM listings ORDER BY id DESC");
//         $data = [];

//         while ($row = $result->fetch_assoc()) {
//             $data[] = $row;
//         }

//         echo json_encode(["success" => true, "data" => $data]);
//         break;

//     // ✅ GET SINGLE LISTING
//     case 'get_one':
//         $id = $_GET['id'] ?? '';
//         if (!$id) {
//             echo json_encode(["success" => false, "message" => "Missing ID"]);
//             break;
//         }

//         $result = $conn->query("SELECT * FROM listings WHERE id = $id");
//         if ($row = $result->fetch_assoc()) {
//             echo json_encode(["success" => true, "data" => $row]);
//         } else {
//             echo json_encode(["success" => false, "message" => "Listing not found"]);
//         }
//         break;

//     // ✅ ADD NEW LISTING
//     case 'add':
//         $title = $_POST['title'] ?? '';
//         $price = $_POST['price'] ?? '';
//         $description = $_POST['description'] ?? '';
//         $image = $_POST['image'] ?? '';

//         if ($title == '' || $price == '' || $description == '') {
//             echo json_encode(["success" => false, "message" => "Missing required fields"]);
//             break;
//         }

//         $sql = "INSERT INTO listings (title, price, description, image)
//                 VALUES ('$title', '$price', '$description', '$image')";

//         if ($conn->query($sql)) {
//             echo json_encode(["success" => true, "message" => "Listing added"]);
//         } else {
//             echo json_encode(["success" => false, "message" => "Failed to add listing"]);
//         }
//         break;

//     // ✅ UPDATE LISTING
//     case 'update':
//         $id = $_POST['id'] ?? '';
//         $title = $_POST['title'] ?? '';
//         $price = $_POST['price'] ?? '';
//         $description = $_POST['description'] ?? '';
//         $image = $_POST['image'] ?? '';

//         if (!$id || $title == '' || $price == '' || $description == '') {
//             echo json_encode(["success" => false, "message" => "Missing required fields"]);
//             break;
//         }

//         $sql = "UPDATE listings SET 
//                 title='$title', price='$price', 
//                 description='$description', image='$image' 
//                 WHERE id=$id";

//         if ($conn->query($sql)) {
//             echo json_encode(["success" => true, "message" => "Listing updated"]);
//         } else {
//             echo json_encode(["success" => false, "message" => "Failed to update listing"]);
//         }
//         break;

//     // ✅ DELETE LISTING
//     case 'delete':
//         $id = $_POST['id'] ?? '';

//         if (!$id) {
//             echo json_encode(["success" => false, "message" => "Missing ID"]);
//             break;
//         }

//         $sql = "DELETE FROM listings WHERE id = $id";

//         if ($conn->query($sql)) {
//             echo json_encode(["success" => true, "message" => "Listing deleted"]);
//         } else {
//             echo json_encode(["success" => false, "message" => "Failed to delete listing"]);
//         }
//         break;

//     // ❌ INVALID ACTION
//     default:
//         echo json_encode(["success" => false, "message" => "Invalid action"]);
//         break;
// }

// $conn->close();
// ?>  