import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/utils/appcolors.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo
              ClipOval(
                child: Image.asset(
                  'assets/applogo.jpg',
                  height: 80,
                ),
              ),
              const SizedBox(height: 20),

              // App Name
              Text(
                "Quran Kareem App",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),

              // App Tagline
              Text(
                "Listen, Watch, and Learn the Holy Quran with Urdu Translation",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // App Description
              Text(
                "The Quran Kareem App is designed for those who want to listen to and watch the Holy Quran "
                "with Urdu translation. It also provides prayer times based on location and a Qibla direction finder.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Key Features Section
              _buildFeatureTile(Icons.audiotrack,
                  "Listen to Quran Recitation with Urdu Translation"),
              _buildFeatureTile(Icons.play_circle_fill,
                  "Watch Quran Video with Urdu Translation"),
              _buildFeatureTile(Icons.download,
                  "Download & Store Quran Audio for Offline Use"),
              _buildFeatureTile(
                  Icons.compass_calibration, "Qibla Direction Finder"),
              _buildFeatureTile(
                  Icons.access_time, "Accurate Prayer Times Based on Location"),
              const SizedBox(height: 20),

              // Contact Information
              // const Divider(),
              // const SizedBox(height: 10),
              // Text(
              //   "Contact Us",
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     color: AppColors.primary,
              //   ),
              // ),
              // const SizedBox(height: 10),
              // _buildContactTile(
              //     Icons.email, "Email", "contact@qurankareem.com"),
              // _buildContactTile(
              //     Icons.language, "Website", "www.qurankareem.com"),
              // _buildContactTile(Icons.facebook, "Facebook", "/qurankareem"),
              // _buildContactTile(Icons.video_library, "YouTube", "/qurankareem"),
              // const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildContactTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 30),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
    );
  }
}
