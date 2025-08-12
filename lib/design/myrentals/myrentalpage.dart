import 'package:flutter/material.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/design/myrentals/itemsrent.dart';
// import 'package:rent/temp/data.dart' hide ImagesLinks;

class MyRentalPage extends StatelessWidget {
  const MyRentalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ white background
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Rentals',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.cyan.shade700,
              borderRadius: BorderRadius.circular(4),
            ),
            width: 28,
            height: 28,
            child: Image.network(
              ImgLinks.profileImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.btnBgColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ItemsRent()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10), // ✅ Replaces Divider
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 8, right: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(228, 213, 213, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 28,
                            color: Color.fromARGB(255, 66, 63, 63),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search How to & More',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 66, 63, 63),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 66, 63, 63),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: const Text(
                              'GO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15), // ✅ Replaces Divider
            const Divider(height: 1, thickness: 0.5),

            for (int i = 1; i < 10; i++) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Column(
                  children: () {
                    List<Map<String, dynamic>> buttons = [];
                    if (i == 1) {
                      buttons = [
                        {
                          'label': 'Rent Out',
                          'color': Colors.cyan.shade700,
                          'item': 'ultrapod',
                          'listed By': 'john David',
                        },
                        {
                          'label': 'Pending',
                          'color': Colors.amber[900]!,
                          'item': 'ultrapod',
                          'listed By': 'john david',
                        },
                        {
                          'label': 'Pending',
                          'color': Colors.amber[900]!,
                          'item': 'q32',
                          'listed By': 'John David',
                        },
                        {
                          'label': 'Closed',
                          'color': Colors.green,
                          'item': 'q32',
                          'listed By': 'John David',
                        },
                      ];
                    } else if (i == 2) {
                      buttons = [
                        {
                          'label': 'Closed',
                          'color': Colors.green,
                          'item': 'q32',
                          'listed By': 'john David',
                        },
                        {
                          'label': 'Pending',
                          'color': Colors.amber[900]!,
                          'item': 'q32',
                          'listed By': 'john David',
                        },
                        {
                          'label': 'Pending',
                          'color': Colors.amber[900]!,
                          'item': 'q32',
                          'listed By': 'john David',
                        },
                        {
                          'label': 'Pending',
                          'color': Colors.amber[900]!,
                          'item': 'q32',
                          'listed By': 'John Dvid',
                        },
                      ];
                    }

                    List<Widget> rows = [];
                    for (int j = 0; j < buttons.length; j += 2) {
                      rows.add(
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _buildRentalItemWithCustomButton(
                                  buttons[j]['item'],
                                  buttons[j]['label'],
                                  buttons[j]['color'],
                                  buttons[j]['listed By'],
                                ),
                              ),
                            ),
                            if (j + 1 < buttons.length)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: _buildRentalItemWithCustomButton(
                                    buttons[j + 1]['item'],
                                    buttons[j + 1]['label'],
                                    buttons[j + 1]['color'],
                                    buttons[j + 1]['listed By'],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                      rows.add(const SizedBox(height: 12));
                    }
                    return rows;
                  }(),
                ),
              ),
              const SizedBox(height: 10), // ✅ Replaces Divider
            ],
          ],
        ),
      ),
    );
  }

  static Widget _buildRentalItemWithCustomButton(
    String itemName,
    String buttonText,
    Color color,
    String listedBy,
  ) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.question_mark,
                size: 36,
                color: Colors.grey,
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 30,
            child: Column(
              children: [
                _circleIcon(Icons.remove_red_eye, Colors.cyan),
                const SizedBox(height: 6),
                _circleIcon(Icons.delete, Colors.redAccent),
              ],
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(90, 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {},
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Listed By: $listedBy',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 19, 19, 19),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _circleIcon(IconData icon, Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Center(child: Icon(icon, size: 18, color: color)),
    );
  }
}
