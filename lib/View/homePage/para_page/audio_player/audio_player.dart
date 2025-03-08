import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_kareem/utils/appcolors.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SurahDetailScreen extends StatefulWidget {
  final int parahIndex;

  const SurahDetailScreen({Key? key, required this.parahIndex})
      : super(key: key);

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late ScrollController _scrollController;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String? _audioUrl;
  int currentAyah = 0;
  final Connectivity _connectivity = Connectivity();
  ValueNotifier<double> downloadProgress = ValueNotifier(0.0);
  bool isDownloading = false;

  List<Map<String, String>> arabicText = [];
  List<int> ayahTimestamps = []; // Ayah start times in seconds

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _scrollController = ScrollController();
    arabicText = getSurahVerses(widget.parahIndex);

    _audioPlayer.durationStream.listen((d) {
      if (d != null) {
        setState(() => duration = d);
      }
    });

    _audioPlayer.positionStream.listen((p) {
      setState(() {
        position = p;
        updateCurrentAyah();
      });
    });

    _preloadAudio(); // Preload audio on screen load
  }

  Future<void> _preloadAudio() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/parah_${widget.parahIndex}.mp3';
    final file = File(filePath);

    if (await file.exists()) {
      await _audioPlayer.setFilePath(filePath);
    } else {
      _audioUrl = await quran.getAudioURLBySurah(widget.parahIndex);
      if (_audioUrl != null) {
        await _audioPlayer.setUrl(_audioUrl!);
      }
    }
  }

  List<Map<String, String>> getSurahVerses(int surahNumber) {
    int totalVerses = quran.getVerseCount(surahNumber);
    List<Map<String, String>> verses = [];

    for (int i = 1; i <= totalVerses; i++) {
      verses.add({
        "arabic": quran.getVerse(surahNumber, i, verseEndSymbol: true),
        "urdu": quran.getVerseTranslation(surahNumber, i,
            translation: quran.Translation.urdu,
            ),
      });
    }

    return verses;
  }

  void updateCurrentAyah() {
    // Offset in seconds where actual Surah begins (adjust based on audio file)
    const int audioOffset = 5; // Adjust this value if needed

    int newAyah = ((position.inSeconds - audioOffset) ~/ 6)
        .clamp(0, arabicText.length - 1);

    if (newAyah != currentAyah) {
      setState(() {
        currentAyah = newAyah;
      });

      _scrollController.animateTo(
        currentAyah * 60.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> toggleFunction() async {
    try {
      if (_audioPlayer.processingState == ProcessingState.loading ||
          _audioPlayer.processingState == ProcessingState.buffering) {
        return; // Prevent multiple taps while loading
      }

      if (isPlaying) {
        _audioPlayer.pause();
        setState(() {
          isPlaying = false; // Update UI when paused
        });
      } else {
        // Ensure audio is preloaded before playing
        if (_audioPlayer.duration == null) {
          // Check if audio is not loaded
          await _preloadAudio(); // Load the audio file if not loaded
        }

        _audioPlayer.play();
        setState(() {
          isPlaying = true; // Update UI when playing
        });
      }
    } catch (e) {
      print("Error in toggleFunction: $e");
    }
  }

  Future<String?> downloadAudio(int parahIndex) async {
    try {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }

      var connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception("No internet connection");
      }

      final audioUrl = await quran.getAudioURLBySurah(parahIndex);
      if (audioUrl == null || audioUrl.isEmpty) {
        throw Exception("Invalid audio URL");
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/parah_$parahIndex.mp3';
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
          backgroundColor: AppColors.primary, colorText: AppColors.whitColor);
      return filePath;
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      Get.snackbar('Error', 'Failed to download audio.',
          colorText: AppColors.whitColor, backgroundColor: Colors.red);
      return null;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor.withOpacity(.9),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          quran.getSurahName(widget.parahIndex),
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Expanded(
            //   child: ListView.builder(
            //     controller: _scrollController,
            //     itemCount: arabicText.length,
            //     itemBuilder: (context, index) {
            //       return AnimatedContainer(
            //         duration: Duration(milliseconds: 00),
            //         padding: const EdgeInsets.all(15),
            //         margin: const EdgeInsets.symmetric(vertical: 5),
            //         decoration: BoxDecoration(
            //           color: index == currentAyah
            //               // ignore: deprecated_member_use
            //               ? AppColors.primary.withOpacity(0.3)
            //               : Colors.transparent,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Text(
            //           arabicText[index],
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 28,
            //             fontWeight: FontWeight.w500,
            //             color: index == currentAyah
            //                 ? AppColors.primary
            //                 : Colors.black,
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: arabicText.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: index == currentAyah
                          ? AppColors.primary.withOpacity(0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Arabic Ayah
                        Text(
                          arabicText[index]["arabic"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: index == currentAyah
                                ? AppColors.primary
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Urdu Translation
                        Text(
                          arabicText[index]["urdu"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
              activeColor: AppColors.primary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(position), style: TextStyle(fontSize: 16)),
                Text(_formatDuration(duration), style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon:
                      Icon(Icons.replay_10, size: 40, color: AppColors.primary),
                  onPressed: () {
                    _audioPlayer.seek(position - Duration(seconds: 10));
                  },
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50, color: AppColors.primary),
                  onPressed: () {
                    setState(() {
                      toggleFunction();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.forward_10,
                      size: 40, color: AppColors.primary),
                  onPressed: () {
                    _audioPlayer.seek(position + Duration(seconds: 10));
                  },
                ),
                isDownloading
                    ? Center(
                        child: SpinKitFadingCircle(
                          color: AppColors.primary,
                          size: 50.0,
                        ),
                      )
                    : IconButton(
                        icon: Icon(Icons.download,
                            size: 30, color: AppColors.primary),
                        onPressed: () => downloadAudio(widget.parahIndex),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
