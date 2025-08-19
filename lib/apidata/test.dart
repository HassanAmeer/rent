// class User {
//   userinfo() {
//     print("dghjkufg");
//     print("dfiox");

//     print("eirgk");

//     print("dfdjk");
//   }

//   rajisterUser({required name, required ali}) {
//     print(name);
//   }
// }
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Function 1
  int add(int a, int b) {
    return a + b;
  }

  // Function 2
  int multiply(int a, int b) {
    return a * b;
  }

  // Function 3 (Main function jo upar wale functions call karega)
  void calculate() {
    int sum = add(5, 10);
    int product = multiply(3, 4);

    print("Sum = $sum");
    print("Product = $product");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Function Demo")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            calculate(); // Button press par function call
          },
          child: const Text("Click Me"),
        ),
      ),
    );
  }
}
