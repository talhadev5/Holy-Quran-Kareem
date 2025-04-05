import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quran_kareem/controllers/add_controller.dart';
import 'package:quran_kareem/utils/appcolors.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  Location _location = Location();
  double? latitude, longitude;
  MyAdController controller = Get.put(MyAdController());
  @override
  void initState() {
    super.initState();
    controller.loadBannerAd();  
  }

  Future<bool> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    LocationData position = await _location.getLocation();
    latitude = position.latitude;
    longitude = position.longitude;

    return latitude != null && longitude != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:
            Text("Prayer Times", style: TextStyle(color: AppColors.whitColor)),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.whitColor),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.whitColor),
            child: FutureBuilder<bool>(
              future: getLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: AppColors.primary,
                      size: 50.0,
                    ),
                  );
                }

                if (snapshot.hasError || snapshot.data == false) {
                  return Center(
                    child: Text(
                      "Failed to get location. Please enable GPS.",
                      style: TextStyle(color: AppColors.primary, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (latitude == null || longitude == null) {
                  return Center(
                    child: Text(
                      "Could not determine location.",
                      style: TextStyle(color: AppColors.primary, fontSize: 16),
                    ),
                  );
                }

                final myCoordinates = Coordinates(latitude!, longitude!);
                final params = CalculationMethod.karachi.getParameters();
                params.madhab = Madhab.hanafi;
                final prayerTimes = PrayerTimes.today(myCoordinates, params);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    prayerTimeCard("Fajr", prayerTimes.fajr, Icons.wb_sunny),
                    prayerTimeCard("Dhuhr", prayerTimes.dhuhr, Icons.wb_cloudy),
                    prayerTimeCard("Asr", prayerTimes.asr, Icons.wb_twilight),
                    prayerTimeCard(
                        "Maghrib", prayerTimes.maghrib, Icons.nights_stay),
                    prayerTimeCard(
                        "Isha", prayerTimes.isha, Icons.nightlight_round),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GetBuilder<MyAdController>(
              builder: (controller) {
                if (controller.bannerAd != null) {
                  return Container(
                    color: Colors.white,
                    width: controller.bannerAd!.size.width.toDouble(),
                    height: controller.bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: controller.bannerAd!),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget prayerTimeCard(String prayer, DateTime time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primary),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: Icon(icon, color: AppColors.whitColor, size: 30),
          title: Text(
            prayer,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.whitColor),
          ),
          trailing: Text(
            DateFormat.jm().format(time),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whitColor),
          ),
        ),
      ),
    );
  }
}
