import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,

        title: Text(
          "The Community Powered Rental Platform",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  labelText: 'items',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.location_city),
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 150),
              child: Text(
                "Contact information :",

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 120),

              child: Text(
                "Contact The Local Rent",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '''If you have any questions or need assistance, feel free to reach out to us. We’re here to help!
            
            ''',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
            ),

            SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.only(right: 210),
              child: Text(
                "Contect us",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(height: 5),

            Text('''Email: thelocalrentllc@gmail.com
Hours: 09:00 AM - 06:00 PM PKT (Monday to Friday)'''),

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(right: 210),
              child: Text(
                "follow us :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
