import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/design/home_page.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../apidata/user.dart';
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryColor),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mainColor,
                  Colors.black,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logorent.png', width: 100)
                        .animate()
                        .fadeIn(
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 800),
                        )
                        .scale(),
                    const SizedBox(height: 30),
                    _buildTextField(
                      controller: emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 500),
                          duration: const Duration(milliseconds: 800),
                        ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 700),
                          duration: const Duration(milliseconds: 800),
                        ),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    const SizedBox(height: 16),
                    _buildSignupButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: AppColors.cardBgColor.withOpacity(0.8),
        prefixIcon: Icon(prefixIcon, color: AppColors.mainColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryColor),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.btnBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.btnBgColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
            toast("Please fill all fields", backgroundColor: Colors.red);
            return;
          }
          await ref.read(userDataClass).login(
                email: emailController.text,
                password: passwordController.text,
              );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: ref.watch(userDataClass).isLoading == true
            ? const DotLoader(color: Colors.white)
            : const Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    ).animate().fadeIn(
          delay: const Duration(milliseconds: 900),
          duration: const Duration(milliseconds: 800),
        );
  }

  Widget _buildSignupButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SignupPage(),
          ),
        );
      },
      child: const Text(
        "Don't have an account? Sign Up",
        style: TextStyle(
          color: AppColors.textAccentColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ).animate().fadeIn(
          delay: const Duration(milliseconds: 1100),
          duration: const Duration(milliseconds: 800),
        );
  }
}