import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class BroadcastPage extends StatefulWidget {
  final String type; 
  final String url;
  final int duration;
  final String orgId;

  const BroadcastPage({
    super.key,
    required this.type,
    required this.url,
    required this.duration,
    required this.orgId,
  });

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}


class _BroadcastPageState extends State<BroadcastPage> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    print("🎬 ========== BroadcastPage Initialized ==========");
    print("🎬 Type: ${widget.type}");
    print("🎬 URL: ${widget.url}");
    print("🎬 Duration: ${widget.duration}");
    print("🎬 OrgId: ${widget.orgId}");

    if (widget.type == 'video') {
      print("📹 Initializing VideoPlayer...");
      _videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          print("✅ VideoPlayer initialized successfully");
          setState(() {});
          _videoController?.play();
          print("▶️ Video started playing");
        }).catchError((error) {
          print("❌ VideoPlayer initialization failed: $error");
          setState(() {
            _hasError = true;
            _errorMessage = 'Video failed to load: $error';
          });
        });
    } else if (widget.type == 'youtube') {
      print("📺 Initializing YouTubePlayer...");
      final videoId = YoutubePlayer.convertUrlToId(widget.url);
      print("📺 Extracted Video ID: $videoId");
      
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
        );
        print("✅ YouTubePlayer initialized successfully");
      } else {
        print("❌ Failed to extract YouTube video ID from URL");
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid YouTube URL';
        });
      }
    } else {
      print("❌ Unsupported broadcast type: ${widget.type}");
      setState(() {
        _hasError = true;
        _errorMessage = 'Unsupported broadcast type: ${widget.type}';
      });
    }

    // Auto-close after duration
    Future.delayed(Duration(seconds: widget.duration), () {
      print("⏰ Duration expired, closing BroadcastPage");
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    print("🗑️ BroadcastPage disposing...");
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _hasError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : widget.type == 'video' && _videoController != null
                    ? _videoController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : const CircularProgressIndicator(color: Colors.white)
                    : widget.type == 'youtube' && _youtubeController != null
                        ? YoutubePlayer(controller: _youtubeController!)
                        : const Text(
                            'Loading broadcast...',
                            style: TextStyle(color: Colors.white),
                          ),
          ),
          // Close button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () {
                print("❌ Manual close button pressed");
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

