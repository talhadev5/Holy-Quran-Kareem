// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/View/homePage/para_page/audio_player/audio_player.dart';
import 'package:quran_kareem/View/homePage/para_page/para.dart';
import 'package:quran_kareem/View/save_localy/save_data.dart';
import 'package:quran_kareem/controllers/surah_controller.dart';
import 'package:quran_kareem/utils/appcolors.dart';

class SurahListScreen extends StatelessWidget {
  final SurahController controller =
      Get.put(SurahController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor.withOpacity(.9),
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Surah List',
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
            PopupMenuButton<int>(
              icon: Icon(Icons.more_vert, color: AppColors.whitColor),
              color: Colors.white,
              elevation: 5,
              onSelected: (value) {
                if (value == 1) {
                  Get.to(() => LocalySaveData()); // Navigate to Local Save Data
                } else if (value == 2) {
                  Get.to(() => ParaListScreen()); // Navigate to Para List
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Download Surah"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Para List"),
                ),
              ],
            ),
          ]),
      body: Column(
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
              () => controller.filteredParahs.isEmpty
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
                      itemCount: controller.filteredParahs.length,
                      itemBuilder: (context, index) {
                        var parah = controller.filteredParahs[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                                () => SurahDetailScreen(parahIndex: index + 1));
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
                                parah['transliteration']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Text(
                                parah['name']!,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
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
    );
  }
}
