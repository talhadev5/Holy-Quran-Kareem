import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_kareem/View/homePage/video_page/quran_translation.dart';
import 'package:quran_kareem/utils/appcolors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuranVideoPage extends StatefulWidget {
  const QuranVideoPage({super.key});

  @override
  State<QuranVideoPage> createState() => _QuranVideoPageState();
}

class _QuranVideoPageState extends State<QuranVideoPage> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  bool _muted = false;
  int _currentIndex = 0; // Track the playing video index

  bool isSearching = false; // To track search state
  String searchQuery = ""; // Search query

  final List<String> _ids = [
    'SvxbJYwhLI4',
    '8-n8wCYr-5Y',
    '_lSyciE7y1Y',
    'qPAEwcEiky0',
    'MzZgoTw9JEQ',
    'hNfrBtSD5_U',
    'W3xS6PJtlT8',
    '3ReNAczOS-s',
    'pFYjNEOh69k',
    'l3jgALV8xEg',
    'IWmF8xCJU4A',
    'booNajuoCac',
    'KDqICEDCteY',
    'h2o4BoYXCOQ',
    'ixzbC4MB4lc',
    'PwsDuoT_ulw',
    'qQN8f3JQU04',
    'xDI9M9daAA0',
    '6_1nQSEIP04',
    'NAcvHzhRgks',
    'mS38frM9QZk',
    '34lwueTwr8s',
    'Qt5gSwU9wko',
    'yC_jqwmVqvs',
    '4Xfca9KSBnQ',
    'mGQ6iod7mGc',
    'Qxl3A4Ln5jk',
    'xp_9zDAeGxg',
    'kFktO9iyIbw',
    'XJUCsGn_7ps',
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

    _playerState = PlayerState.unknown;
    _videoMetaData = const YoutubeMetaData();
  }

  void _listener() {
    if (_isPlayerReady && mounted) {
      setState(() {
        _playerState = _controller.value.playerState;
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
                  'Quran Translation',
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
            PopupMenuButton<int>(
              icon: Icon(Icons.more_vert,
                  color: AppColors.whitColor), // Changed icon
              color: Colors.white,
              elevation: 5,
              onSelected: (value) {
                if (value == 1) {
                  Get.to(() =>
                      QuranTransaltionPage()); // Navigate to Local Save Data
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Quran Arabic & Urdu"),
                ),
              ],
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
