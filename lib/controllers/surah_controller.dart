import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;

class SurahController extends GetxController {
  var searchQuery = ''.obs;
  final List<Map<String, String>> allParahs = [];

  @override
  void onInit() {
    super.onInit();
    _generateParahs(); // Generate the list once on init
  }

  void _generateParahs() {
    for (int index = 1; index <= 114; index++) {
      allParahs.add({
        'number': index.toString(),
        'name': quran.getSurahNameArabic(index),
        'transliteration': quran.getSurahName(index),
      });
    }
  }

  List<Map<String, String>> get filteredParahs {
    if (searchQuery.value.isEmpty) {
      return allParahs; // Return full list if search is empty
    }
    return allParahs.where((parah) {
      return parah['transliteration']!
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
    }).toList();
  }
}
