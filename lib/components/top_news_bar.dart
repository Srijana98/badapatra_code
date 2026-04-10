
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
import 'package:flutter/material.dart';

class TopNewsBar extends StatefulWidget {
  final List<dynamic> notices;

  const TopNewsBar({
    Key? key,
    required this.notices,
  }) : super(key: key);

  @override
  State<TopNewsBar> createState() => _TopNewsBarState();
}

class _TopNewsBarState extends State<TopNewsBar> {
  final ScrollController _hController = ScrollController();
  bool _isAutoScrolling = false;
  bool _isUserInteracting = false;
  final double _scrollPixelsPerSecond = 20.0; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScrollFromPosition(0.0);
    });
  }

  @override
  void dispose() {
    _isAutoScrolling = false;
    _hController.dispose();
    super.dispose();
  }

  void _stopAutoScroll() {
    _isAutoScrolling = false;
    if (_hController.hasClients) {
      _hController.jumpTo(_hController.offset); // Stops exact current position
    }
  }

  void _pauseAutoScroll() {
    if (!_isUserInteracting) {
      _isUserInteracting = true;
      _stopAutoScroll();
    }
  }

  void _resumeAutoScroll() {
    if (_isUserInteracting) {
      _isUserInteracting = false;
      if (_hController.hasClients) {
        _startAutoScrollFromPosition(_hController.offset); 
      }
    }
  }

  Future<void> _startAutoScrollFromPosition(double fromPosition) async {
    _stopAutoScroll();
    _isAutoScrolling = true;

    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted || !_hController.hasClients || !_isAutoScrolling) return;

    if (fromPosition > 0) _hController.jumpTo(fromPosition);

    _runNativeScrollLoop();
  }

  Future<void> _runNativeScrollLoop() async {
    if (!mounted || !_hController.hasClients || !_isAutoScrolling || _isUserInteracting) return;

    final double currentScroll = _hController.offset;
    final double maxScroll = _hController.position.maxScrollExtent;

    if (maxScroll <= 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) _runNativeScrollLoop();
      return;
    }

    final double remainingDistance = maxScroll - currentScroll;
    final int durationMs = ((remainingDistance / _scrollPixelsPerSecond) * 1000).toInt();

    if (remainingDistance > 0) {
      try {
        await _hController.animateTo(
          maxScroll,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.linear,
        );
      } catch (e) {
        debugPrint("Auto-scroll interrupted safely");
      }
    }

    // When it reaches the end, jump to start immediately to loop seamlessly
    if (_isAutoScrolling && mounted && !_isUserInteracting) {
      if (_hController.hasClients) {
        _hController.jumpTo(0);
        _runNativeScrollLoop();
      }
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
              // For Mobile Touch interaction
              onPointerDown: (_) => _pauseAutoScroll(),
              onPointerUp: (_) => _resumeAutoScroll(),
              onPointerCancel: (_) => _resumeAutoScroll(),
              child: MouseRegion(
                // For TV Mouse/Pointer interaction
                onEnter: (_) => _pauseAutoScroll(),
                onExit: (_) => _resumeAutoScroll(),
                child: SingleChildScrollView(
                  controller: _hController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(), // Disables manual bounce
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      // Repeating the text creates a perfect continuous Marquee effect
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

  // Helper method to strip HTML tags
  String _stripHtmlTags(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}