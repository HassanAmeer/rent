import 'package:flutter/material.dart';
import 'package:rent/constants/scrensizes.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "My Blogs",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Getting stated guide",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          " Started here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: ScreenSize.width * .45,
                      height: ScreenSize.height * .2,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Top tips ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "for listing your icon",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: ScreenSize.width * .4,

                      height: ScreenSize.height * .2,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Getting stated guide",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              " Started here",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.cyan,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: ScreenSize.width * .4,
                          height: ScreenSize.height * .2,
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Top tips ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "for listing your icon",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: ScreenSize.width * .45,

                          height: ScreenSize.height * .2,
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
