// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/View/menuPage/about_us.dart';
import 'package:quran_kareem/View/menuPage/faqs.dart';
import 'package:quran_kareem/utils/appcolors.dart';
import 'package:share_plus/share_plus.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primary, // Set your preferred color
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            // ✅ App Icon
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green.shade100,
              backgroundImage: AssetImage('assets/applogo.jpg'),
            ),
            const SizedBox(height: 10),
            // ✅ App Title
            const Text(
              "Holy Quran Majeed",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            // ✅ Menu Options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMenuItem(Icons.info_outline, "About Us", () {
                    Get.to(() => AboutUsPage());
                  }),
                  _buildMenuItem(Icons.help_outline, "FAQs", () {
                    Get.to(() => FAQSPage());
                  }),
                  // _buildMenuItem(Icons.grid_view, "Terms & Conditions", () {
                  //   Get.to(() => TermsConditionPage());
                  // }),
                  _buildMenuItem(Icons.share, "Share App", () {
                    Share.share(
                        "Check out this amazing Quran Kareem App: https://play.google.com/store/apps/details?id=com.yourapp.qurankareem");
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menu Item Widget
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.primary.withOpacity(.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}
