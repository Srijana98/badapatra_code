// original code

// import 'package:flutter/material.dart';
// import 'package:marquee/marquee.dart';


// class TopNewsBar extends StatefulWidget {
//   final List<dynamic> notices;
 
//   const TopNewsBar({
//     Key? key,
//     required this.notices,
//   }) : super(key: key);

//   @override
//   State<TopNewsBar> createState() => _TopNewsBarState();
// }

// class _TopNewsBarState extends State<TopNewsBar> {


  

//   @override
//   Widget build(BuildContext context) {
//     if (widget.notices.isEmpty) {
//       return const SizedBox.shrink();
//     }
    
//     final allNotices = widget.notices
//         .map((n) => _stripHtmlTags(n['notices'] ?? ''))
//         .join('   ||   ');
    
//     return Container(
//       height: 35,
//       color: Color(0xFF233072),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,  
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             color: Colors.red.shade700,
//             alignment: Alignment.center,  
//             child: const Text(
//               'सूचनाहरू(**):',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ),
//           ),

//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Marquee(
//                 text: allNotices,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 scrollAxis: Axis.horizontal,
//                 blankSpace: 50,
//                // velocity: 40,
//                velocity: 20,
//                 pauseAfterRound: Duration.zero,
//                 startPadding: 10,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to strip HTML tags
//   String _stripHtmlTags(String htmlText) {
//     return htmlText
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll('&nbsp;', ' ')
//         .trim();
//   }
// }




// code for the user interaction


// import 'package:flutter/material.dart';


// class TopNewsBar extends StatefulWidget {
//   final List<dynamic> notices;

//   const TopNewsBar({
//     Key? key,
//     required this.notices,
//   }) : super(key: key);

//   @override
//   State<TopNewsBar> createState() => _TopNewsBarState();
// }

// class _TopNewsBarState extends State<TopNewsBar> {
//   final ScrollController _hController = ScrollController();
//   bool _isAutoScrolling = false;
//   bool _isUserInteracting = false;
//   final double _scrollPixelsPerSecond = 20.0; 

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startAutoScrollFromPosition(0.0);
//     });
//   }

//   @override
//   void dispose() {
//     _isAutoScrolling = false;
//     _hController.dispose();
//     super.dispose();
//   }

//   void _stopAutoScroll() {
//     _isAutoScrolling = false;
//     if (_hController.hasClients) {
//       _hController.jumpTo(_hController.offset); 
//     }
//   }

//   void _pauseAutoScroll() {
//     if (!_isUserInteracting) {
//       _isUserInteracting = true;
//       _stopAutoScroll();
//     }
//   }

//   void _resumeAutoScroll() {
//     if (_isUserInteracting) {
//       _isUserInteracting = false;
//       if (_hController.hasClients) {
//         _startAutoScrollFromPosition(_hController.offset); 
//       }
//     }
//   }

//   Future<void> _startAutoScrollFromPosition(double fromPosition) async {
//     _stopAutoScroll();
//     _isAutoScrolling = true;

//     //await Future.delayed(const Duration(milliseconds: 100));
//     await Future.delayed(const Duration(milliseconds: 50));
//     if (!mounted || !_hController.hasClients || !_isAutoScrolling) return;

//     if (fromPosition > 0) _hController.jumpTo(fromPosition);

//     _runNativeScrollLoop();
//   }

//   Future<void> _runNativeScrollLoop() async {
//     if (!mounted || !_hController.hasClients || !_isAutoScrolling || _isUserInteracting) return;

//     final double currentScroll = _hController.offset;
//     final double maxScroll = _hController.position.maxScrollExtent;

//     if (maxScroll <= 0) {
//       await Future.delayed(const Duration(seconds: 1));
//       if (mounted) _runNativeScrollLoop();
//       return;
//     }

//     final double remainingDistance = maxScroll - currentScroll;
//     final int durationMs = ((remainingDistance / _scrollPixelsPerSecond) * 1000).toInt();

//     if (remainingDistance > 0) {
//       try {
//         await _hController.animateTo(
//           maxScroll,
//           duration: Duration(milliseconds: durationMs),
//           curve: Curves.linear,
//         );
//       } catch (e) {
//         debugPrint("Auto-scroll interrupted safely");
//       }
//     }

//     // When it reaches the end, jump to start immediately to loop seamlessly
//     if (_isAutoScrolling && mounted && !_isUserInteracting) {
//       if (_hController.hasClients) {
//         _hController.jumpTo(0);
//         _runNativeScrollLoop();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.notices.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     final allNotices = widget.notices
//         .map((n) => _stripHtmlTags(n['notices'] ?? ''))
//         .join('   ||   ');

//     return Container(
//       height: 35,
//       color: const Color(0xFF233072),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             color: Colors.red.shade700,
//             alignment: Alignment.center,
//             child: const Text(
//               'सूचनाहरू(**):',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Listener(
//               // For Mobile Touch interaction
//               onPointerDown: (_) => _pauseAutoScroll(),
//               onPointerUp: (_) => _resumeAutoScroll(),
//               onPointerCancel: (_) => _resumeAutoScroll(),
//               child: MouseRegion(
//                 // For TV Mouse/Pointer interaction
//                 onEnter: (_) => _pauseAutoScroll(),
//                 onExit: (_) => _resumeAutoScroll(),
//                 child: SingleChildScrollView(
//                   controller: _hController,
//                   scrollDirection: Axis.horizontal,
//                 //  physics: const ClampingScrollPhysics(), // Disables manual bounce
//                 physics: const NeverScrollableScrollPhysics(),
//                   child: Container(
//                     alignment: Alignment.centerLeft,
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       // Repeating the text creates a perfect continuous Marquee effect
//                       "$allNotices   ||   $allNotices   ||   $allNotices",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to strip HTML tags
//   String _stripHtmlTags(String htmlText) {
//     return htmlText
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll('&nbsp;', ' ')
//         .trim();
//   }
// }






// code for the smooth scrolling


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TopNewsBar extends StatefulWidget {
  final List<dynamic> notices;

  const TopNewsBar({
    Key? key,
    required this.notices,
  }) : super(key: key);

  @override
  State<TopNewsBar> createState() => _TopNewsBarState();
}

class _TopNewsBarState extends State<TopNewsBar>
    with SingleTickerProviderStateMixin {
  final ScrollController _hController = ScrollController();
  bool _isUserInteracting = false;
  final double _scrollPixelsPerSecond = 20.0;
  Ticker? _ticker;
  double _lastTickTime = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ticker!.start();
    });
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _hController.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_isUserInteracting) return;
    if (!_hController.hasClients) return;

    final double maxScroll = _hController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final double currentTime = elapsed.inMicroseconds / 1000000.0;
    final double delta = currentTime - _lastTickTime;
    _lastTickTime = currentTime;

    // Clamp delta to avoid huge jumps after pause/resume
    final double safeDelta = delta.clamp(0.0, 0.05);

    double newOffset = _hController.offset + (_scrollPixelsPerSecond * safeDelta);

    // Seamless loop
    if (newOffset >= maxScroll) {
      newOffset = newOffset - maxScroll;
    }

    _hController.jumpTo(newOffset);
  }

  void _pauseAutoScroll() {
    if (!_isUserInteracting) {
      _isUserInteracting = true;
    }
  }

  void _resumeAutoScroll() {
    if (_isUserInteracting) {
      _lastTickTime = 0; // Reset delta to avoid position jump on resume
      _isUserInteracting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notices.isEmpty) {
      return const SizedBox.shrink();
    }

    final allNotices = widget.notices
        .map((n) => _stripHtmlTags(n['notices'] ?? ''))
        .join('   ||   ');

    return Container(
      height: 35,
      color: const Color(0xFF233072),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            color: Colors.red.shade700,
            alignment: Alignment.center,
            child: const Text(
              'सूचनाहरू(**):',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Listener(
              onPointerDown: (_) => _pauseAutoScroll(),
              onPointerUp: (_) => _resumeAutoScroll(),
              onPointerCancel: (_) => _resumeAutoScroll(),
              child: MouseRegion(
                onEnter: (_) => _pauseAutoScroll(),
                onExit: (_) => _resumeAutoScroll(),
                child: SingleChildScrollView(
                  controller: _hController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "$allNotices   ||   $allNotices   ||   $allNotices",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _stripHtmlTags(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}

