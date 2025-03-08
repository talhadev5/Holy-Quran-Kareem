import 'package:get/get.dart';

class ParaController extends GetxController {
  var searchQuery = ''.obs;
  final List<Map<String, String>> allParas = [];

  /// List of 30 Juz (Para) names in Arabic
  final List<String> paraNamesArabic = [
    "الم",
    "سيقول",
    "تلك الرسل",
    "لن تنالوا",
    "والمحصنات",
    "لا يحب الله",
    "وإذا سمعوا",
    "ولو أننا",
    "قال الملا",
    "واعلموا",
    "يعتذرون",
    "وما من دابة",
    "وما أبرئ",
    "ربما",
    "سبحان الذي",
    "قال ألم",
    "اقترب للناس",
    "قد أفلح",
    "وقال الذين",
    "أمن خلق",
    "أتل ما أوحي",
    "ومن يقنت",
    "ومالي",
    "فمن أظلم",
    "إليه يرد",
    "حم",
    "قال فما خطبكم",
    "قد سمع الله",
    "تبارك",
    "عم يتساءلون"
  ];

  /// List of 30 Juz (Para) names in **English transliteration**
  final List<String> paraNamesEnglish = [
    "Alif Laam Meem",
    "Sayaqool",
    "Tilkal Rusul",
    "Lan Tanaalu",
    "Wal Muhsanat",
    "La Yuhibbullah",
    "Wa Iza Samiu",
    "Wa Lau Anna",
    "Qalal Mala",
    "Wa A’lamu",
    "Ya’tadhiruna",
    "Wa Mamin Da’abba",
    "Wa Maaa Ubarri’u",
    "Rubama",
    "Subhanallazi",
    "Qal Alam",
    "Iqtarabat",
    "Qad Aflaha",
    "Wa Qalallazina",
    "Aman Khalaq",
    "Utlu Ma Oohi",
    "Wa Manyaqnut",
    "Wa Mali",
    "Faman Azlam",
    "Elahe Yuraddu",
    "Ha-Meem",
    "Qala Fama Khatbukum",
    "Qad Sami Allah",
    "Tabarakallazi",
    "Amma Yatasa’aloon"
  ];

  @override
  void onInit() {
    super.onInit();
    generateParas(); // Generate the list on initialization
  }

  /// Populate the `allParas` list with both **Arabic and English transliteration**
  void generateParas() {
    for (int index = 0; index < 30; index++) {
      allParas.add({
        'number': (index + 1).toString(), // Para number (1 to 30)
        'name': paraNamesArabic[index], // Para name in Arabic
        'transliteration':
            paraNamesEnglish[index], // Para name in English transliteration
      });
    }
  }

  /// Filtered list based on search input
  List<Map<String, String>> get filteredParas {
    if (searchQuery.value.isEmpty) {
      return allParas; // Return full list if no search input
    }
    return allParas.where((para) {
      return para['transliteration']!
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
    }).toList();
  }
}
