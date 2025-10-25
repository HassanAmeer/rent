import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/apidata/user.dart' show userDataClass;
// import 'package:rent/apidata/user.dart';
import 'package:rent/constants/appColors.dart';
import 'dart:convert';
import 'package:rent/services/goto.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/widgets/dotloader.dart';

import 'login.dart'; // ✅ Update path if needed

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      backgroundColor: Colors.indigo[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),

                /* its take child */
                // ElevatedButton(
                //   onPressed: () async {
                //     if (nameController.text.isEmpty ||
                //         emailController.text.isEmpty ||
                //         passwordController.text.isEmpty) {
                //       toast(
                //         "Please fill all fields",
                //         backgroundColor: Colors.red,
                //       );
                //       return;
                //     }

                //     await ref
                //         .read(userDataClass)
                //         .register(
                //           name: nameController.text,
                //           email: emailController.text,
                //           password: passwordController.text,
                //         );

                //     // ref
                //     //     .watch(userDataClass)
                //     //     .setLoading(
                //     //       ref.watch(userDataClass).isLoading ? false : true,
                //     //     );
                //   },
                //   child: ref.read(userDataClass).isLoading == true
                //       ? SizedBox(
                //           width: 25,
                //           height: 25,
                //           child: CircularProgressIndicator(
                //             strokeWidth: 2,
                //             color: Colors.cyan,
                //           ),
                //         )
                //       : Text('Signup'),
                //   style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.all(10),
                //     fixedSize: Size(100, 40),
                //     elevation: 30,
                //     shadowColor: Color.fromARGB(255, 6, 0, 55),
                //     side: BorderSide(width: 2, style: BorderStyle.solid),
                //     shape: StadiumBorder(side: BorderSide.none),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      toast(
                        "Please fill all fields",
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    await ref
                        .read(userDataClass)
                        .register(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 12, 12, 12),
                  ),
                  child: ref.read(userDataClass).isLoading == true
                      ? SizedBox(
                          width: 25,
                          height: 25,
                          child: DotLoader(size: 12),
                        )
                      : const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
