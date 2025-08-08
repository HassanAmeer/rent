// import 'package:flutter/material.dart';
// import 'package:rent/Apiservices/user.dart';
// import 'package:rent/constants/scrensizes.dart';
// import 'package:rent/notificationsdetails.dart';
// import 'package:rent/profile_details_page.dart';
// import 'package:rent/temp/data.dart';
// import 'constants/data.dart' hide AppAssets, ImagesLinks;

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<NotificationPage> {





//   List<Map<String, String>> notifications = [
//     {
//       "name": "Ashley",
//       "message": "New Booking for Vintage Type Writer",
//       "date": "2025-02-17",
//       "time": "17:48:59",
//       "image": "https://randomuser.me/api/portraits/women/1.jpg",
//     },
//     {
//       "name": "Ashley A.",
//       "message": "New Booking for Vintage Type Writer",
//       "date": "2024-12-19",
//       "time": "17:52:09",
//       "image": "https://randomuser.me/api/portraits/women/2.jpg",
//     },
//     {
//       "name": "Ashley A.",
//       "message": "New Booking for Kayake",
//       "date": "2024-10-25",
//       "time": "13:47:49",
//       "image": "https://randomuser.me/api/portraits/women/3.jpg",
//     },
//   ];

//   void _deleteNotification(int index) {
//     setState(() {
//       notifications.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: Image.asset(AppAssets.logo, width: 100),

//         actions: [
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfileDetailsPage()),
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.cyan.shade700,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               width: 35,
//               height: 35,
//               clipBehavior: Clip.antiAlias,
//               child: Image.network(ImagesLinks.profileImage, fit: BoxFit.cover),
//             ),
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 10),
//           Padding(
//             padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
//             child: Text(
//               "Notification Users",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 final item = notifications[index];
//                 return Container(
//                   height: ScreenSize.height * 0.23,

//                   margin: const EdgeInsets.only(bottom: 16),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade200),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         spreadRadius: 1,
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(24),
//                             child: Image.network(
//                               item['image']!,
//                               width: 48,
//                               height: 48,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Positioned(
//                             top: 0,
//                             right: 0,
//                             child: Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: const BoxDecoration(
//                                 color: Colors.cyan,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.notifications,
//                                 size: 14,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               item['name']!,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(item['message']!),
//                             const SizedBox(height: 6),
//                             Row(
//                               children: [
//                                 Text(
//                                   item['date']!,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   item['time']!,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const NotificationDetailPage(),
//                                   ),
//                                 );
//                               },
//                               child: const Row(
//                                 children: [
//                                   Icon(
//                                     Icons.keyboard_arrow_down,
//                                     size: 18,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     "Details",
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => _deleteNotification(index),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // 🔻 Placeholder Page: You can customize later
// class NotificationDetailPage extends StatelessWidget {
//   const NotificationDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const NotificationsDetails(); // ✅ Yeh tumhari pehle wali screen hai
//   }
// }
