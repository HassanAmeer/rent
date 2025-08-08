import 'package:flutter/material.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/auth/profile_details_page.dart';
import 'package:rent/temp/data.dart';

class NotificationsDetails extends StatelessWidget {
  final Map<String, dynamic> userData;

  const NotificationsDetails({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 4, 254, 250),
        title: Image.asset(AppAssets.logo, width: 80),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileDetailsPage(),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan,
              ),
              clipBehavior: Clip.antiAlias,
              width: 45,
              height: 45,
              child: Image.network(
                Config.imgUrl + userData['image'],
                semanticLabel: ImagesLinks.profileImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: Colors.white, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "User Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                infoText("👤 Name", userData['name']),
                infoText("📧 Email", userData['email']),
                infoText("📞 Phone", userData['phone']),
                infoText("🆔 CNIC", userData['cnic']),
                infoText("🏙️ City", userData['city']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        "$label: ${value ?? 'N/A'}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
