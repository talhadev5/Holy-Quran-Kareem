import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_kareem/controllers/add_controller.dart';
import 'package:quran_kareem/utils/appcolors.dart';
import 'package:quran_kareem/widget/location_error.dart';

class QiblahCompass extends StatefulWidget {
  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  MyAdController controller = Get.put(MyAdController());

  @override
  void initState() {
    _checkLocationStatus();
    controller.loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Qiblah Direction",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.whitColor),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.whitColor),
            child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: AppColors.primary,
                      size: 50.0,
                    ),
                  );
                }

                final LocationStatus? locationStatus =
                    snapshot.data as LocationStatus?;

                if (locationStatus?.enabled == true) {
                  switch (locationStatus?.status) {
                    case LocationPermission.always:
                    case LocationPermission.whileInUse:
                      return const QiblahCompassWidget();

                    case LocationPermission.denied:
                      return LocationErrorWidget(
                        error: "Location service permission denied",
                        callback: _checkLocationStatus,
                      );

                    case LocationPermission.deniedForever:
                      return LocationErrorWidget(
                        error: "Location service Denied Forever!",
                        callback: _checkLocationStatus,
                      );

                    default:
                      return Container();
                  }
                } else {
                  return LocationErrorWidget(
                    error: "Please enable Location service",
                    callback: _checkLocationStatus,
                  );
                }
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
}

class QiblahCompassWidget extends StatelessWidget {
  const QiblahCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primary,
              size: 50.0,
            ),
          );
        }

        final qiblahDirection = snapshot.data!;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Transform.rotate(
              //   angle: (qiblahDirection.direction * (pi / 180)),
              //   child: Image.asset(
              //     'assets/qiblahcompass.jpg',
              //     width: 300,
              //     height: 300,
              //   ),
              // ),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // Compass Image with Glow Effect
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.whitColor,
                          // blurRadius: 30,
                          // spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: (qiblahDirection.direction * (pi / 180) * -1),
                      child: SvgPicture.asset(
                        'assets/compas.svg',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ),

                  // Qiblah Needle
                  Transform.rotate(
                    angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/needle.svg',
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              // const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
