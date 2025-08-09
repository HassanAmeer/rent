import 'package:flutter/material.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final nameController = TextEditingController(text: "John David");
  final phoneController = TextEditingController(text: "03012345678");
  final emailController = TextEditingController(
    text: "hasanameer386@gmail.com",
  );
  final aboutController = TextEditingController(
    text: "Avid traveler\nEnjoy mountains and outdoors",
  );
  final addressController = TextEditingController(
    text: "2452 Rooney Rd\nChattanooga , TN 21497",
  );

  bool sendEmails = true;
  bool acceptPrivacy = false;
  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Row with Profile Image and "Pick Images"
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture with edit icon
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d",
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.edit, size: 16, color: Colors.cyan),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 30),

                // Pick Images text
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 25),
                    child: const Text(
                      "Pick Images",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Name field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Phone field
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 10),

            // Email field
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 10),

            // About Us multiline field
            TextField(
              controller: aboutController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "About Us",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Address multiline field
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Verified By text
            Row(
              children: const [
                Text(
                  "Verified By",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text(
                  "google",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Send Emails toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Send Emails",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: sendEmails,
                  onChanged: (value) {
                    setState(() {
                      sendEmails = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Privacy Policy and Terms checkboxes
            Row(
              children: [
                Checkbox(
                  value: acceptPrivacy,
                  onChanged: (val) {
                    setState(() {
                      acceptPrivacy = val ?? false;
                    });
                  },
                ),
                const Text("I accept the "),
                GestureDetector(
                  onTap: () {
                    // open privacy policy link
                  },
                  child: const Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Checkbox(
                  value: acceptTerms,
                  onChanged: (val) {
                    setState(() {
                      acceptTerms = val ?? false;
                    });
                  },
                ),
                const Text("Terms and Conditions"),
              ],
            ),

            const SizedBox(height: 20),

            // Update Profile button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: (acceptPrivacy && acceptTerms)
                    ? () {
                        // Profile update logic
                        Navigator.pop(context);
                      }
                    : null, // Disable if not accepted
                child: const Text(
                  "Update Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
