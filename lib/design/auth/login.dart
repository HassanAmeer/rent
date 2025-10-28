import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:rent/apidata/user.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/design/home_page.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../apidata/user.dart';
import '../../constants/appColors.dart';
import 'signup.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final userProvider = ref.watch(userDataClass);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, AppColors.mainColor.shade100],
        ),
      ),

      child: Scaffold(
        // appBar: AppBar(
        //   // title: const Text('Login'),
        //   backgroundColor: Colors.transparent,
        // ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),

                  Image.asset('assets/logorent.png', width: 150)
                      .animate()
                      .slideY(duration: 400.milliseconds)
                      .animate(
                        onPlay: (controller) => controller.repeat(
                          // reverse: false,
                          // period: const Duration(milliseconds: 1500),
                        ),
                      )
                      .shimmer(
                        color: Colors.cyan.shade200,
                        duration: 2.seconds,
                      ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ).animate().slideX(duration: 400.milliseconds),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ).animate().slideX(duration: 400.milliseconds),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        toast(
                          "Please fill all fields",
                          backgroundColor: Colors.red,
                        );
                        return;
                      }

                      // print("fdghjkl");
                      await ref
                          .read(userDataClass)
                          .login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 13, 14, 14),
                    ),
                    child: ref.watch(userDataClass).isLoading == true
                        ? DotLoader()
                        : Text(
                                "Login",
                                style: GoogleFonts.abhayaLibre(
                                  textStyle: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .shimmer(
                                color: Colors.grey,
                                duration: 7.seconds,
                                angle: -2,
                              ),
                  ).animate().slideX(duration: 400.milliseconds),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupPage()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.black),
                    ),
                  ).animate().slideX(duration: 400.milliseconds),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
