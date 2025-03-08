import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/View/navBar.dart';
import 'package:quran_kareem/utils/appcolors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  /// 🔹 **Navigate to Main Screen after 3 seconds**
  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAll(() => MainNavigationPage()); // ✅ Removes Splash from Back Stack
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(
          "assets/applogo.jpg",
        ),
      ),
    );
  }
}
