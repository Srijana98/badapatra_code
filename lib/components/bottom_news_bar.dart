
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

// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class BottomNewsBar extends StatefulWidget {
//   final List<dynamic> newsItems;
//   final String rssType;
//   final String? qrUrl;

//   const BottomNewsBar({
//     super.key,
//     required this.newsItems,
//     required this.rssType,
//     this.qrUrl,
//   });

//   @override
//   State<BottomNewsBar> createState() => _BottomNewsBarState();
// }

// class _BottomNewsBarState extends State<BottomNewsBar> {
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

//    // await Future.delayed(const Duration(milliseconds: 100));
//    await Future.delayed(const Duration(milliseconds: 50)); 
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

   
//     if (_isAutoScrolling && mounted && !_isUserInteracting) {
//       if (_hController.hasClients) {
//         _hController.jumpTo(0);
//         _runNativeScrollLoop();
//       }
//     }
//   }

//   String _buildNewsText() {
//     if (widget.newsItems.isEmpty) return "सूचना उपलब्ध छैन";
//     return widget.newsItems.map((e) => e['title'] ?? '').join("     |     ");
//   }

//   @override
//   Widget build(BuildContext context) {
    

//     final newsText = _buildNewsText();

//     return SizedBox(
//       height: 35,
//       width: double.infinity,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           // 🔴 RED NEWS BAR
//           Container(
//             height: 35,
//             width: double.infinity,
//             color: const Color(0xFFCD0711),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       CustomPaint(
//                         painter: TaperedRedBackgroundPainter(),
//                         size: const Size(double.infinity, 35),
//                       ),
//                       CustomPaint(
//                         painter: WhiteTriangleLabelPainter(),
//                         size: const Size(120, 35),
//                       ),
//                       Positioned.fill(
//                         left: 95,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Listener(
//                             // For Mobile Touch interaction
//                             onPointerDown: (_) => _pauseAutoScroll(),
//                             onPointerUp: (_) => _resumeAutoScroll(),
//                             onPointerCancel: (_) => _resumeAutoScroll(),
//                             child: MouseRegion(
//                               // For TV Mouse/Pointer interaction
//                               onEnter: (_) => _pauseAutoScroll(),
//                               onExit: (_) => _resumeAutoScroll(),
//                               child: SingleChildScrollView(
//                                 controller: _hController,
//                                 scrollDirection: Axis.horizontal,
//                               //  physics: const ClampingScrollPhysics(), // Disables manual bounce
//                               physics: const NeverScrollableScrollPhysics(),
//                                 child: Container(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     // Repeating text 3 times creates the perfect continuous Marquee effect
//                                     "$newsText     |     $newsText     |     $newsText",
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 🔳 BIG QR (OVERFLOW)
//           if (widget.qrUrl != null && widget.qrUrl!.isNotEmpty)
//             Positioned(
//               right: 0,
//               bottom: 0,
//               child: SizedBox(
//                 width: 70,
//                 height: 70,
//                 child: QrImageView(
//                   data: widget.qrUrl!,
//                   version: QrVersions.auto,
//                   gapless: true,
//                   backgroundColor: Colors.white,
//                   errorCorrectionLevel: QrErrorCorrectLevel.H,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
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
//     const textStyle = TextStyle(
//       color: Color(0xFFCD0711),
//       fontSize: 14,
//       fontWeight: FontWeight.bold,
//     );
//     const textSpan = TextSpan(text: text, style: textStyle);
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



// code for the smooth scrolling

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class _BottomNewsBarState extends State<BottomNewsBar>
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
      _lastTickTime = 0; 
      _isUserInteracting = false;
    }
  }

  String _buildNewsText() {
    if (widget.newsItems.isEmpty) return "सूचना उपलब्ध छैन";
    return widget.newsItems.map((e) => e['title'] ?? '').join("     |     ");
  }

  @override
  Widget build(BuildContext context) {
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
                                  child: Text(
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