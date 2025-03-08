// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:quran/quran.dart' as quran;
// import 'package:quran_kareem/utils/appcolors.dart';

// class ParahDetailScreen extends StatefulWidget {
//   final int parahIndex;
//   final String parahName;

//   const ParahDetailScreen({
//     Key? key,
//     required this.parahIndex,
//     required this.parahName,
//   }) : super(key: key);

//   @override
//   _ParahDetailScreenState createState() => _ParahDetailScreenState();
// }

// class _ParahDetailScreenState extends State<ParahDetailScreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final ScrollController _scrollController = ScrollController();
//   final RxDouble downloadProgress = 0.0.obs;

//   List<Map<String, dynamic>> verses = [];
//   bool isPlaying = false;
//   bool isDownloading = false;
//   Duration _position = Duration.zero;
//   Duration _duration = Duration.zero;
//   int currentAyahIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchVersesManually();

//     _audioPlayer.positionStream.listen((pos) {
//       if (mounted) {
//         setState(() {
//           _position = pos;
//         });
//       }
//     });

//     _audioPlayer.durationStream.listen((dur) {
//       if (mounted) {
//         setState(() {
//           _duration = dur ?? Duration.zero;
//         });
//       }
//     });

//     _audioPlayer.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed) {
//         _playNextAyah();
//       }
//     });
//   }

//   Future<void> _fetchVersesManually() async {
//     List<Map<String, dynamic>> fetchedVerses = [];

//     for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
//       int totalAyahs = quran.getVerseCount(surahNumber);

//       for (int ayahNumber = 1; ayahNumber <= totalAyahs; ayahNumber++) {
//         if (quran.getJuzNumber(surahNumber, ayahNumber) == widget.parahIndex) {
//           fetchedVerses.add({
//             'surah': surahNumber,
//             'ayah': ayahNumber,
//             'arabic': quran.getVerse(surahNumber, ayahNumber),
//             'translation': quran.getVerseTranslation(
//               surahNumber,
//               ayahNumber,
//               translation: quran.Translation.urdu,
//             ),
//             'audio': quran.getAudioURLByVerse(surahNumber, ayahNumber),
//           });
//         }
//       }
//     }

//     if (mounted) {
//       setState(() {
//         verses = fetchedVerses;
//       });
//     }
//   }

//   Future<void> _playNextAyah() async {
//     if (currentAyahIndex < verses.length - 1) {
//       currentAyahIndex++;
//       _scrollToCurrentAyah();
//       _playAyahAudio();
//     } else {
//       setState(() {
//         isPlaying = false;
//       });
//     }
//   }

//   Future<void> _playAyahAudio() async {
//     if (verses.isEmpty) return;

//     String filePath = await _getLocalAudioPath(widget.parahIndex);
//     bool fileExists = await File(filePath).exists();

//     try {
//       if (fileExists) {
//         await _audioPlayer.setFilePath(filePath);
//       } else {
//         String? url = verses[currentAyahIndex]['audio'];
//         if (url == null || url.isEmpty) {
//           print("Audio URL not available for this Ayah.");
//           return;
//         }
//         await _audioPlayer.setUrl(url);
//       }

//       await _audioPlayer.play();
//       setState(() {
//         isPlaying = true;
//       });

//       _scrollToCurrentAyah();
//     } catch (e) {
//       Get.snackbar("Error", "Failed to play audio.");
//     }
//   }

//   void _scrollToCurrentAyah() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         currentAyahIndex * 80.0, // Adjust height if needed
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _togglePlayPause() async {
//     if (isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       _playAyahAudio();
//     }
//     setState(() {
//       isPlaying = !isPlaying;
//     });
//   }

//   void _seekForward() {
//     _audioPlayer.seek(_position + Duration(seconds: 10));
//   }

//   void _seekBackward() {
//     _audioPlayer.seek(_position - Duration(seconds: 10));
//   }

//   Future<String> _getLocalAudioPath(int parahIndex) async {
//     final directory = await getApplicationDocumentsDirectory();
//     return '${directory.path}/parah_$parahIndex.mp3';
//   }

//   Future<String?> downloadAudio(int parahIndex) async {
//     try {
//       if (!await Permission.storage.isGranted) {
//         await Permission.storage.request();
//       }

//       final audioUrl = await quran.getAudioURLBySurah(parahIndex);
//       if (audioUrl == null || audioUrl.isEmpty) {
//         throw Exception("Invalid audio URL");
//       }

//       final filePath = await _getLocalAudioPath(parahIndex);
//       final dio = Dio();

//       setState(() {
//         isDownloading = true;
//       });
//       downloadProgress.value = 0.0;

//       await dio.download(audioUrl, filePath,
//           onReceiveProgress: (received, total) {
//         if (total != -1) {
//           downloadProgress.value = received / total;
//         }
//       });

//       setState(() {
//         isDownloading = false;
//       });

//       Get.snackbar('Success', 'Audio downloaded successfully!',
//           backgroundColor: Colors.green, colorText: Colors.white);
//       return filePath;
//     } catch (e) {
//       setState(() {
//         isDownloading = false;
//       });
//       Get.snackbar('Error', 'Failed to download audio.',
//           colorText: Colors.white, backgroundColor: Colors.red);
//       return null;
//     }
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Parah: ${widget.parahName}",
//           style: const TextStyle(color: AppColors.whitColor),
//         ),
//         backgroundColor: AppColors.primary,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back_ios),
//           color: AppColors.whitColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Expanded(
//               child: verses.isEmpty
//                   ? Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       controller: _scrollController,
//                       itemCount: verses.length,
//                       itemBuilder: (context, index) {
//                         final verse = verses[index];
//                         return ListTile(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           title: Text(verse['arabic'],
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w500,
//                               )),
//                           subtitle: Text(verse['translation'],
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w500,
//                               )),
//                           tileColor: currentAyahIndex == index
//                               ? Colors.green.shade100
//                               : null,
//                         );
//                       },
//                     ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                     icon: Icon(Icons.replay_10,
//                         size: 30, color: AppColors.primary),
//                     onPressed: _seekBackward),
//                 IconButton(
//                     icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
//                         size: 30, color: AppColors.primary),
//                     onPressed: _togglePlayPause),
//                 IconButton(
//                     icon: Icon(Icons.forward_10,
//                         size: 30, color: AppColors.primary),
//                     onPressed: _seekForward),
//                 IconButton(
//                     icon: Icon(Icons.download,
//                         size: 30, color: AppColors.primary),
//                     onPressed: () {
//                       downloadAudio(widget.parahIndex);
//                     }),
//               ],
//             ),
//             if (isDownloading)
//               // Obx(() =>
//               LinearProgressIndicator(
//                 // value: downloadProgress.value,
//                 color: AppColors.primary,
//               )
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_kareem/utils/appcolors.dart';

class ParahDetailScreen extends StatefulWidget {
  final int parahIndex;
  final String parahName;

  const ParahDetailScreen({
    Key? key,
    required this.parahIndex,
    required this.parahName,
  }) : super(key: key);

  @override
  _ParahDetailScreenState createState() => _ParahDetailScreenState();
}

class _ParahDetailScreenState extends State<ParahDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  final RxDouble downloadProgress = 0.0.obs;

  List<Map<String, dynamic>> verses = [];
  bool isPlaying = false;
  bool isDownloading = false;
  int currentAyahIndex = 0;
  Duration _position = Duration.zero;
  List<GlobalKey> verseKeys = [];

  @override
  void initState() {
    super.initState();
    _fetchVersesManually();
    _setupAudioListeners();
  }

  void _setupAudioListeners() {
    _audioPlayer.positionStream.listen((pos) {
      if (mounted) setState(() {});
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextAyah();
      }
    });
  }

  Future<void> _fetchVersesManually() async {
    List<Map<String, dynamic>> fetchedVerses = [];
    for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
      int totalAyahs = quran.getVerseCount(surahNumber);
      for (int ayahNumber = 1; ayahNumber <= totalAyahs; ayahNumber++) {
        if (quran.getJuzNumber(surahNumber, ayahNumber) == widget.parahIndex) {
          fetchedVerses.add({
            'surah': surahNumber,
            'ayah': ayahNumber,
            'arabic': quran.getVerse(surahNumber, ayahNumber),
            'translation': quran.getVerseTranslation(surahNumber, ayahNumber,
                translation: quran.Translation.urdu),
            'audio': quran.getAudioURLByVerse(surahNumber, ayahNumber),
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        verses = fetchedVerses;
        verseKeys = List.generate(verses.length, (index) => GlobalKey());
      });
    }
  }

  Future<void> _playAyahAudio() async {
    if (verses.isEmpty) return;

    try {
      String? url = verses[currentAyahIndex]['audio'];
      if (url == null || url.isEmpty) {
        Get.snackbar("Error", "Audio URL not available for this Ayah.");
        return;
      }
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();

      setState(() {
        isPlaying = true;
      });
      _scrollToCurrentAyah();
    } catch (e) {
      Get.snackbar("Error", "Failed to play audio.");
    }
  }

  Future<void> _playNextAyah() async {
    if (currentAyahIndex < verses.length - 1) {
      setState(() {
        currentAyahIndex++;
      });
      _scrollToCurrentAyah();
      _playAyahAudio();
    } else {
      setState(() {
        isPlaying = false;
      });
    }
  }

  void _scrollToCurrentAyah() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        currentAyahIndex * 100.0, // Adjust height based on your UI
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // Future<void> downloadAudio() async {
  //   try {
  //     if (!await Permission.storage.isGranted) {
  //       await Permission.storage.request();
  //     }

  //     final audioUrl = await quran.getAudioURLBySurah(widget.parahIndex);
  //     if (audioUrl == null || audioUrl.isEmpty) {
  //       throw Exception("Invalid audio URL");
  //     }

  //     final filePath = await _getLocalAudioPath(widget.parahIndex);
  //     final dio = Dio();
  //     setState(() => isDownloading = true);
  //     downloadProgress.value = 0.0;

  //     await dio.download(audioUrl, filePath,
  //         onReceiveProgress: (received, total) {
  //       if (total != -1) {
  //         downloadProgress.value = received / total;
  //       }
  //     });

  //     setState(() => isDownloading = false);
  //     Get.snackbar('Success', 'Audio downloaded successfully!',
  //         backgroundColor: Colors.green, colorText: Colors.white);
  //   } catch (e) {
  //     setState(() => isDownloading = false);
  //     Get.snackbar('Error', 'Failed to download audio.',
  //         colorText: Colors.white, backgroundColor: Colors.red);
  //   }
  // }

  Future<String> _getLocalAudioPath(int parahIndex) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/parah_$parahIndex.mp3';
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      _playAyahAudio();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekForward() {
    _audioPlayer.seek(_position + Duration(seconds: 10));
  }

  void _seekBackward() {
    _audioPlayer.seek(_position - Duration(seconds: 10));
  }

   Future<String?> downloadAudio(int parahIndex) async {
    try {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }

      final audioUrl = await quran.getAudioURLBySurah(parahIndex);
      if (audioUrl == null || audioUrl.isEmpty) {
        throw Exception("Invalid audio URL");
      }

      final filePath = await _getLocalAudioPath(parahIndex);
      final dio = Dio();

      setState(() {
        isDownloading = true;
      });
      downloadProgress.value = 0.0;

      await dio.download(audioUrl, filePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          downloadProgress.value = received / total;
        }
      });

      setState(() {
        isDownloading = false;
      });

      Get.snackbar('Success', 'Audio downloaded successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
      return filePath;
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      Get.snackbar('Error', 'Failed to download audio.',
          colorText: Colors.white, backgroundColor: Colors.red);
      return null;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Parah: ${widget.parahName}",
          style: const TextStyle(color: AppColors.whitColor),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
          color: AppColors.whitColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: verses.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: verses.length,
                      itemBuilder: (context, index) {
                        final verse = verses[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(verse['arabic'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              )),
                          subtitle: Text(verse['translation'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              )),
                          tileColor: currentAyahIndex == index
                              ? Colors.green.shade100
                              : null,
                        );
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.replay_10,
                        size: 30, color: AppColors.primary),
                    onPressed: _seekBackward),
                IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 30, color: AppColors.primary),
                    onPressed: () {
                      _togglePlayPause();
                    }),
                IconButton(
                    icon: Icon(Icons.forward_10,
                        size: 30, color: AppColors.primary),
                    onPressed: _seekForward),
                IconButton(
                    icon: Icon(Icons.download,
                        size: 30, color: AppColors.primary),
                    onPressed: () {
                      downloadAudio(widget.parahIndex);
                    }),
              ],
            ),
            if (isDownloading)
              // Obx(() =>
              LinearProgressIndicator(
                // value: downloadProgress.value,
                color: AppColors.primary,
              )
            // ),
          ],
        ),
      ),
    );
  }
}
