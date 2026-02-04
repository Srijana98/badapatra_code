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

  @override
  void initState() {
    super.initState();

    if (widget.type == 'video') {
      _videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });
    } else if (widget.type == 'youtube') {
      _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.url) ?? '',
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            widget.type == 'video' && _videoController != null
                ? VideoPlayer(_videoController!)
                : widget.type == 'youtube' && _youtubeController != null
                ? YoutubePlayer(controller: _youtubeController!)
                : Text('Unsupported broadcast type'),
      ),
    );
  }
}