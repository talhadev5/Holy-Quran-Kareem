import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/utils/appcolors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuranTransaltionPage extends StatefulWidget {
  const QuranTransaltionPage({super.key});

  @override
  State<QuranTransaltionPage> createState() => _QuranTransaltionPageState();
}

class _QuranTransaltionPageState extends State<QuranTransaltionPage> {
  late YoutubePlayerController _controller;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  bool _muted = false;
  int _currentIndex = 0; // Track the playing video index

  bool isSearching = false; // To track search state
  String searchQuery = ""; // Search query

  final List<String> _ids = [
    'dXxh8tmUimc',
    'vI2SSVfEbqo',
    'PuCPBtL-Afg',
    'TVU_ioV5VHU',
    'OHkqFZaHnHc',
    'xYmQ4u34dVs',
    '-7bRkBWwZps',
    'Se7rwviZAYk',
    'kV7X8UazbiM',
    '3TVg-gsoBQI',
    'UqV4-PMXhlA',
    'm9_xKqXBE2I',
    'L7Es0nS5t5k',
    'Vnlg3dBDQ2U',
    '_9ZGdg3ned4',
    'OeWCd-wPU7w',
    'sqxtYDxJMj4',
    'ztYZsu7VkwE',
    'rk3HzBpON-s',
    'SXTeDQQh5Yo',
    'jw2Ivpvzq40',
    '7oyTqWDBrTA',
    '-5fTXd_FOLg',
    '9dtCljGhlzw',
    'C8PNZK8gJSg',
    '3ChHhArhE4A',
    '7WUb9R2Vyyo',
    'GM0hTWenz6M',
    'uThyW2XtHwY',
    'HIVx-Nxm1No',
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        enableCaption: true,
      ),
    )..addListener(_listener);

    _videoMetaData = const YoutubeMetaData();
  }

  void _listener() {
    if (_isPlayerReady && mounted) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }

  void _playVideo(int index) {
    setState(() {
      _currentIndex = index; // Update the selected video index
      _controller.load(_ids[index]);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Filtered video list based on search query
  List<String> get filteredVideos {
    if (searchQuery.isEmpty) {
      return _ids;
    }
    return _ids.where((id) {
      String title =
          'Quran Para ${_ids.indexOf(id) + 1} With Urdu Translation | Quran Urdu Translation';
      return title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _videoMetaData.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          setState(() {
            _isPlayerReady = true;
          });
        },
        onEnded: (data) {
          int nextIndex = (_currentIndex + 1) % _ids.length;
          _playVideo(nextIndex);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Next Video Started!")),
          );
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.primary,
          title: isSearching
              ? CupertinoSearchTextField(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.whitColor.withValues(alpha: 0.5)),
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isSearching = false;
                    });
                  },
                )
              : const Text(
                  'Quran Tilawat',
                  style: TextStyle(color: Colors.white),
                ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search,
                  color: Colors.white),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  searchQuery = ""; // Reset search when closing search bar
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            player,
            _buildPlayerControls(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(_videoMetaData.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            SizedBox(height: Get.height * .02),
            Expanded(
              child: filteredVideos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Match Found for: \"$searchQuery\"",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Please search by Para number",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredVideos.length,
                      itemBuilder: (context, index) {
                        String videoId = filteredVideos[index];
                        bool isSelected =
                            _ids.indexOf(videoId) == _currentIndex;
                        return ListTile(
                          tileColor: isSelected
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.white,
                          leading: Image.network(
                            'https://img.youtube.com/vi/$videoId/0.jpg',
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            'Quran Para ${_ids.indexOf(videoId) + 1} With Urdu Translation | Quran Urdu Translation',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.black,
                            ),
                          ),
                          subtitle: Text('Quran Tilawat'),
                          onTap: () => _playVideo(_ids.indexOf(videoId)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: _isPlayerReady && _currentIndex > 0
              ? () => _playVideo(_currentIndex - 1)
              : null,
        ),
        IconButton(
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: _isPlayerReady
              ? () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                }
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: _isPlayerReady && _currentIndex < _ids.length - 1
              ? () => _playVideo(_currentIndex + 1)
              : null,
        ),
        IconButton(
          icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
          onPressed: _isPlayerReady
              ? () {
                  setState(() {
                    _muted ? _controller.unMute() : _controller.mute();
                    _muted = !_muted;
                  });
                }
              : null,
        ),
      ],
    );
  }
}
