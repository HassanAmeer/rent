// import 'package:flutter/material.dart';
// import 'listing_edit_page.dart';

// class ListingDetailPage extends StatelessWidget {
//   final String title;
//   final String imageUrl;
//   final String description;

//   const ListingDetailPage({
//     super.key,
//     required this.title,
//     required this.imageUrl,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Listing Details",
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.cyan,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       backgroundColor: Colors.grey[100],
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 imageUrl,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(description, style: const TextStyle(fontSize: 16)),
//             const Spacer(),
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => ListingEditPage(
//                   //       title: title,
//                   //       description: description,
//                   //       imageUrl: imageUrl,
//                   //     ),
//                   //   ),
//                   // );
//                 },
//                 icon: const Icon(Icons.edit),
//                 label: const Text("Edit"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 12,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ListingDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ListingDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Sabhi values ko extract karke ek string banayenge
    final valuesOnly = data.values.map((v) => v.toString()).join('\n');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing Detail'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            valuesOnly,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        ),
      ),
    );
  }
}
