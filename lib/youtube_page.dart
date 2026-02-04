
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class GalleryCarousel extends StatefulWidget {
  final List<dynamic> galleryItems;

  const GalleryCarousel({
    Key? key,
    required this.galleryItems,
  }) : super(key: key);

  @override
  State<GalleryCarousel> createState() => _GalleryCarouselState();
}

class _GalleryCarouselState extends State<GalleryCarousel> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    if (widget.galleryItems.isEmpty) return;

    _timer?.cancel();
    
    // Get duration of current item
    int duration = _getCurrentDuration();
    
    _timer = Timer(Duration(seconds: duration), () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.galleryItems.length;
        });
        _startAutoSlide(); // Restart timer with new duration
      }
    });
  }

  int _getCurrentDuration() {
    if (widget.galleryItems.isEmpty) return 10;
    
    var currentItem = widget.galleryItems[_currentIndex];
    String durationStr = currentItem['display_duration']?.toString() ?? '10';
    return int.tryParse(durationStr) ?? 10;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.galleryItems.isEmpty) {
      return const SizedBox.shrink();
    }

    var currentItem = widget.galleryItems[_currentIndex];
    String mediaType = currentItem['media_type'] ?? 'IMAGE';
    String title = currentItem['title'] ?? '';
    List<dynamic> mediaUrls = currentItem['media_url'] ?? [];
    String mediaUrl = mediaUrls.isNotEmpty ? mediaUrls[0] : '';

    return GalleryCard(
      imageUrl: mediaUrl,
      title: title,
      mediaType: mediaType,
     duration: _getCurrentDuration(),
    );
  }
}

// class GalleryCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String mediaType;
//    final int duration; 

//   const GalleryCard({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//     required this.mediaType,
//     required this.duration,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: const BorderSide(color: Colors.red, width: 3),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Image/Video Section
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(8),
//               topRight: Radius.circular(8),
//             ),
//             child: _buildMediaContent(),
//           ),
          
//           // Caption Section
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(8),
//                 bottomRight: Radius.circular(8),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Icon(
//                   mediaType == 'VIDEO' ? Icons.play_circle_outline : Icons.image,
//                   color: Colors.red,
//                   size: 22,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMediaContent() {
//     if (mediaType == 'VIDEO') {
//       return Container(
//         height: 180,
//         width: double.infinity,
//         color: Colors.black,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Image.network(
//               _getYouTubeThumbnail(imageUrl),
//               height: 180,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   height: 180,
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.videocam, size: 50, color: Colors.grey),
//                 );
//               },
//             ),
//             const Icon(
//               Icons.play_circle_outline,
//               size: 64,
//               color: Colors.white,
//             ),
//           ],
//         ),
//       );
//     } else {
//       // IMAGE
//       return Image.network(
//         imageUrl,
//         height: 180,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return Container(
//             height: 180,
//             color: Colors.grey[300],
//             child: const Icon(Icons.image, size: 50, color: Colors.grey),
//           );
//         },
//       );
//     }
//   }

//   String _getYouTubeThumbnail(String url) {
//     // Extract video ID from YouTube URL
//     final videoId = url.split('/').last;
//     return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
//   }
// }

class GalleryCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String mediaType;
  final int duration;

  const GalleryCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.mediaType,
    required this.duration,
  }) : super(key: key);

  @override
  State<GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<GalleryCard> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.mediaType == 'VIDEO') {
      final videoId = _extractYoutubeId(widget.imageUrl);

      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.red, width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: _buildMedia(),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia() {
    if (widget.mediaType == 'VIDEO' && _controller != null) {
      return YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
      );
    }

    return Image.network(
      widget.imageUrl,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  String _extractYoutubeId(String url) {
    if (url.contains("embed/")) {
      return url.split("embed/").last;
    }
    return YoutubePlayer.convertUrlToId(url) ?? '';
  }
}
