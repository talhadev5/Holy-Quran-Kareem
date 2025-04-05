// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_kareem/View/homePage/para_page/audio_player/parah_audio.dart';
import 'package:quran_kareem/View/save_localy/save_data.dart';
import 'package:quran_kareem/controllers/add_controller.dart';
import 'package:quran_kareem/controllers/para_controller.dart';
import 'package:quran_kareem/utils/appcolors.dart';

class ParaListScreen extends StatefulWidget {
  @override
  State<ParaListScreen> createState() => _ParaListScreenState();
}

class _ParaListScreenState extends State<ParaListScreen> {
  final ParaController controller = Get.put(ParaController(), permanent: true);
  MyAdController adController = Get.put(MyAdController());
  @override
  void initState() {
    super.initState();
    adController.loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor.withOpacity(.9),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Parah List',
          style: TextStyle(color: AppColors.whitColor),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: AppColors.whitColor,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => LocalySaveData());
              },
              icon: Icon(
                Icons.save_alt,
                color: AppColors.whitColor,
              ))
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Type to search..',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.whitColor,
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => controller.filteredParas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No Match Found for: "${controller.searchQuery.value}"',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Please search by Surah Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.filteredParas.length,
                          itemBuilder: (context, index) {
                            var parah = controller.filteredParas[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => ParahDetailScreen(
                                      parahIndex: index + 1,
                                      parahName: parah['name'] ?? '',
                                    ));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.whitColor,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/Star.svg',
                                          width: 50,
                                          height: 50,
                                        ),
                                        Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: Text(
                                    parah['transliteration'] ?? 'unknown',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: Text(
                                    parah['name'] ?? 'unknown',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
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
