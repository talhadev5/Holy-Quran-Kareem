import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/utils/appcolors.dart';

class FAQSPage extends StatefulWidget {
  const FAQSPage({super.key});

  @override
  _FAQSPageState createState() => _FAQSPageState();
}

class _FAQSPageState extends State<FAQSPage> {
  Map<int, bool> _isExpanded = {}; // Track expanded state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "FAQs",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Find answers to common questions about the Quran Kareem App.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),

              // FAQs List
              _buildFAQTile(0, "📖 What is the Quran Kareem App?",
                  "Quran Kareem App allows you to listen to and watch the Holy Quran with Urdu translation. It also provides prayer times and Qibla direction based on your location."),
              _buildFAQTile(1, "🔊 How can I listen to Quran audio?",
                  "Simply open the app, navigate to the Surah or Parah section, and tap on the play button to listen to Quran recitation with Urdu translation."),
              _buildFAQTile(2, "📥 Can I download Quran audio for offline use?",
                  "Yes! You can download Quran recitations and store them in the app to listen without an internet connection."),
              _buildFAQTile(3, "🕌 How does the Qibla direction feature work?",
                  "Our app uses your device’s location to accurately point towards the Qibla, ensuring you pray in the correct direction."),
              _buildFAQTile(4, "🕋 How does the prayer time feature work?",
                  "The app automatically detects your location and provides accurate prayer times based on Islamic calculation methods."),
              _buildFAQTile(5, "🌙 Is the app free to use?",
                  "Yes, the Quran Kareem App is completely free to use with all features unlocked."),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQTile(int index, String question, String answer) {
    bool isOpen = _isExpanded[index] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 0, // Small elevation when expanded
      color: isOpen ? AppColors.primary : Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.transparent), // Light grey border
      ),
      child: ExpansionTile(
        iconColor: isOpen ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.transparent), // Light grey border
        ),
        leading: Icon(
          Icons.help_outline,
          color: isOpen ? Colors.white : AppColors.primary,
        ),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isOpen ? Colors.white : Colors.black,
          ),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded[index] = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
