import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/View/homePage/card.dart';
import 'package:quran_kareem/View/homePage/video_page/quran_video.dart';
import 'package:quran_kareem/View/prayer_page/prayer_page.dart';
import 'package:quran_kareem/View/qibla_page/qibla.dart';
import 'package:quran_kareem/utils/appcolors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primary, // Set your preferred color
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: SvgPicture.asset("assets/banner.svg"),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1, // Square shape
                ),
                itemCount: featureItems.length,
                itemBuilder: (context, index) {
                  return FeatureCard(
                    title: featureItems[index]['title'],
                    // icon: featureItems[index]['icon'],
                    onTap: featureItems[index]['onTap'],
                    // image: featureItems[index]['image'],
                    icon: featureItems[index].containsKey('icon')
                        ? featureItems[index]['icon']
                        : null,
                    image: featureItems[index].containsKey('image')
                        ? featureItems[index]['image']
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// List of Features
final List<Map<String, dynamic>> featureItems = [
  {
    "title": "Quran Audio",
    "image": 'assets/icon 1.svg',
    "onTap": () {
      Get.toNamed('/paraPage');
    }
  },
  {
    "title": "Quran Video",
    "image": 'assets/icon 2.svg',
    "onTap": () {
      Get.to(() => QuranVideoPage());
    }
  },
  {
    "title": "Prayer Time",
    "image": 'assets/icon 3.svg',
    "onTap": () {
      Get.to(() => PrayerPage());
    }
  },
  {
    "title": "Qibla Direction",
    "image": 'assets/icon 4.svg',
    "onTap": () {
      Get.to(() => QiblahCompass());
    }
  },
  {
    "title": "Rate Us",
    "icon": Icons.rate_review_outlined,
    "onTap": () async {
      const url = "https://play.google.com/store/apps/details?id=com.yourapp.qurankareem";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        print("Could not open Play Store");
      }
    }
  },
  {
    "title": "Share App",
    "icon": Icons.share,
    "onTap": () {
      Share.share(
          "Check out this amazing Holy Quran Majeed: https://play.google.com/store/apps/details?id=com.yourapp.qurankareem");
    }
  },
];
