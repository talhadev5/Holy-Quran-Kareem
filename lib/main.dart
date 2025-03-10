import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/View/Splash/splash.dart';
import 'package:quran_kareem/View/homePage/homaPage.dart';
import 'package:quran_kareem/View/homePage/para_page/surah_page.dart';
import 'package:quran_kareem/View/menuPage/menuPage.dart';
import 'package:quran_kareem/View/prayer_page/prayer_page.dart';
import 'package:quran_kareem/View/qibla_page/qibla.dart';
import 'package:quran_kareem/utils/appcolors.dart';

void main() {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();

  // Change the status bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.primary, // Change this to your desired color
    statusBarIconBrightness: Brightness.light,
  ));
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
