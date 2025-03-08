import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_kareem/utils/appcolors.dart';

class LocalySaveData extends StatefulWidget {
  const LocalySaveData({super.key});

  @override
  State<LocalySaveData> createState() => _LocalySaveDataState();
}

class _LocalySaveDataState extends State<LocalySaveData> {
  List<File> savedAudioFiles = [];
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  File? currentFile; // Track the currently playing file

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadSavedAudioFiles();

    // Listen for changes in player state
    _audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() => isPlaying = true);
      } else {
        setState(() => isPlaying = false);
      }
    });
  }

  Future<void> _loadSavedAudioFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory
        .listSync()
        .where((file) => file.path.endsWith('.mp3'))
        .toList();
    setState(() {
      savedAudioFiles = files.map((file) => File(file.path)).toList();
    });
  }

  Future<void> _deleteAudioFile(File file) async {
    try {
      await file.delete();
      _loadSavedAudioFiles();
      Get.snackbar('Deleted', 'Audio file removed successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete file.');
    }
  }

  Future<void> _togglePlayback(File file) async {
    if (isPlaying && currentFile == file) {
      _audioPlayer.pause();
    } else {
      await _audioPlayer.setFilePath(file.path);
      _audioPlayer.play();
      setState(() => currentFile = file);
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
        title: Text("Saved Audio Files"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadSavedAudioFiles, // Refresh list
          ),
        ],
      ),
      body: savedAudioFiles.isEmpty
          ? Center(
              child: Text(
                "No saved audio files",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: savedAudioFiles.length,
              itemBuilder: (context, index) {
                File file = savedAudioFiles[index];
                bool isCurrentPlaying = isPlaying && currentFile == file;

                return ListTile(
                  title: Text(file.path.split('/').last),
                  leading: Icon(Icons.music_note, color: AppColors.primary),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                            isCurrentPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.primary),
                        onPressed: () => _togglePlayback(file),
                      ),
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(file);
                          }),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmationDialog(File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, size: 60, color: Colors.red),
                SizedBox(height: 10),
                Text(
                  "Confirm Deletion",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Are you sure you want to delete this audio file? This action cannot be undone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.grey[300], // Cancel Button Color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child:
                          Text("Cancel", style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Delete Button Color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteAudioFile(file);
                      },
                      child:
                          Text("Delete", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
