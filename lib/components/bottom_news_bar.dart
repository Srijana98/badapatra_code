
// import 'package:flutter/material.dart';
// import 'package:marquee/marquee.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class BottomNewsBar extends StatelessWidget {
//   final List<dynamic> newsItems;
//   final String rssType;  
//   final String? qrUrl;

//   const BottomNewsBar({
//     super.key,
//     required this.newsItems,
//     required this.rssType,
//     this.qrUrl,
//   });

//   String _buildNewsText() {
//     if (newsItems.isEmpty) return "सूचना उपलब्ध छैन";
//     return newsItems.map((e) => e['title'] ?? '').join("     |     ");
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
//     return SizedBox(
//   height: 35,
//   width: double.infinity,
//   child: Stack(
//     clipBehavior: Clip.none,
//     children: [

//       // 🔴 RED NEWS BAR
//       Container(
//         height: 35,
//         width: double.infinity,
//         color: const Color(0xFFCD0711),
//         child: Row(
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   CustomPaint(
//                     painter: TaperedRedBackgroundPainter(),
//                     size: const Size(double.infinity, 35),
//                   ),
//                   CustomPaint(
//                     painter: WhiteTriangleLabelPainter(),
//                     size: const Size(120, 35),
//                   ),
//                   Positioned.fill(
//                     left: 95,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Marquee(
//                         text: _buildNewsText(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       //  velocity: 30,
//                        velocity: 20,
//                         blankSpace: 120,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       // 🔳 BIG QR (OVERFLOW)
//       if (qrUrl != null && qrUrl!.isNotEmpty)
//         Positioned(
//            right: 0,
//            bottom: 0,
//           child:

//           Positioned(
//   right: 0,
//   bottom: 0,
//   child: SizedBox(
//    width: 70,
//    height: 70,

   
//     child: QrImageView(
//       data: qrUrl!,
//       version: QrVersions.auto,
//       gapless: true, 
//       backgroundColor: Colors.white, 
//       errorCorrectionLevel: QrErrorCorrectLevel.H,
//     ),
//   ),
// ),
//         ),
//     ],
//   ),
// );
//   }
// }

// class TaperedRedBackgroundPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = const Color(0xFFCD0711);

//     final path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width, 0)
//       ..lineTo(size.width, size.height - 5)
//       ..lineTo(0, size.height)
//       ..close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class WhiteTriangleLabelPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.white;

//     final path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width - 30, 0)
//       ..lineTo(size.width, size.height / 2)
//       ..lineTo(size.width - 30, size.height)
//       ..lineTo(0, size.height)
//       ..close();

//     canvas.drawPath(path, paint);

//     const text = "News24Nepal:";
//     final textStyle = TextStyle(
//       color: Color(0xFFCD0711),
//       fontSize: 14,
//       fontWeight: FontWeight.bold,
//     );
//     final textSpan = TextSpan(text: text, style: textStyle);
//     final textPainter = TextPainter(
//       text: textSpan,
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout();

//     textPainter.paint(
//       canvas,
//       Offset(
//         (size.width - 30 - textPainter.width) / 2,
//         (size.height - textPainter.height) / 2,
//       ),
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }


// code for the user interaction

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BottomNewsBar extends StatefulWidget {
  final List<dynamic> newsItems;
  final String rssType;
  final String? qrUrl;

  const BottomNewsBar({
    super.key,
    required this.newsItems,
    required this.rssType,
    this.qrUrl,
  });

  @override
  State<BottomNewsBar> createState() => _BottomNewsBarState();
}

class _BottomNewsBarState extends State<BottomNewsBar> {
  final ScrollController _hController = ScrollController();
  bool _isAutoScrolling = false;
  bool _isUserInteracting = false;
  final double _scrollPixelsPerSecond = 20.0; // Same as your Marquee velocity

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
        _startAutoScrollFromPosition(_hController.offset); // Resumes from same spot
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

  String _buildNewsText() {
    if (widget.newsItems.isEmpty) return "सूचना उपलब्ध छैन";
    return widget.newsItems.map((e) => e['title'] ?? '').join("     |     ");
  }

  @override
  Widget build(BuildContext context) {
    // The previous variable, kept in case you need it later
    // final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final newsText = _buildNewsText();

    return SizedBox(
      height: 35,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 🔴 RED NEWS BAR
          Container(
            height: 35,
            width: double.infinity,
            color: const Color(0xFFCD0711),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: TaperedRedBackgroundPainter(),
                        size: const Size(double.infinity, 35),
                      ),
                      CustomPaint(
                        painter: WhiteTriangleLabelPainter(),
                        size: const Size(120, 35),
                      ),
                      Positioned.fill(
                        left: 95,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  child: Text(
                                    // Repeating text 3 times creates the perfect continuous Marquee effect
                                    "$newsText     |     $newsText     |     $newsText",
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔳 BIG QR (OVERFLOW)
          if (widget.qrUrl != null && widget.qrUrl!.isNotEmpty)
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: 70,
                height: 70,
                child: QrImageView(
                  data: widget.qrUrl!,
                  version: QrVersions.auto,
                  gapless: true,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TaperedRedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFCD0711);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 5)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WhiteTriangleLabelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - 30, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width - 30, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    const text = "News24Nepal:";
    const textStyle = TextStyle(
      color: Color(0xFFCD0711),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    const textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        (size.width - 30 - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

