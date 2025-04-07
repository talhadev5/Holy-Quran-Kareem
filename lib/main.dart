import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/View/Splash/splash.dart';
import 'package:quran_kareem/View/homePage/homaPage.dart';
import 'package:quran_kareem/View/homePage/para_page/surah_page.dart';
import 'package:quran_kareem/View/menuPage/menuPage.dart';
import 'package:quran_kareem/View/prayer_page/prayer_page.dart';
import 'package:quran_kareem/View/qibla_page/qibla.dart';
import 'package:quran_kareem/controllers/add_controller.dart';
import 'package:quran_kareem/utils/appcolors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  final MyAdController adController = Get.put(MyAdController());
  await adController.loadAppOpenAd();
    // Change the status bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.primary, // Change this   to your desired color
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
  // Load and show ad when ready
  adController.loadAppOpenAd(
    onAdLoaded: () {
      adController.showAppOpenAd();
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Kareem',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/menu', page: () => MenuPage()),
        GetPage(name: '/paraPage', page: () => SurahListScreen()),
        GetPage(name: '/prayerPage', page: () => PrayerPage()),
        GetPage(name: '/qiblahCompass', page: () => QiblahCompass())
      ],
    );
  }
}
