import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth/login.dart';
import 'auth/signup.dart';
import 'home_page.dart';
import 'listing/listing_page.dart';

GlobalKey<NavigatorState> contextKey = GlobalKey();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(backgroundColor: Colors.cyan),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
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