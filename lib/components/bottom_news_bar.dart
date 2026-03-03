
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BottomNewsBar extends StatelessWidget {
  final List<dynamic> newsItems;
  final String rssType;  
  final String? qrUrl;

  const BottomNewsBar({
    super.key,
    required this.newsItems,
    required this.rssType,
    this.qrUrl,
  });

  String _buildNewsText() {
    if (newsItems.isEmpty) return "सूचना उपलब्ध छैन";
    return newsItems.map((e) => e['title'] ?? '').join("     |     ");
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // return Container(
    //   height: 35, // Fixed height to match TopNewsBar
    //   width: double.infinity,
    //   color: const Color(0xFFCD0711), 
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       // News bar section
    //       Expanded(
    //         child: Stack(
    //           children: [
    //             CustomPaint(
    //               painter: TaperedRedBackgroundPainter(),
    //               size: const Size(double.infinity, 35),
    //             ),
    //             CustomPaint(
    //               painter: WhiteTriangleLabelPainter(),
    //               size: const Size(120, 35),
    //             ),
    //             Positioned.fill(
    //               left: 95,
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 10),
    //                 child: Marquee(
    //                   text: _buildNewsText(),
    //                   style: const TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w500,
    //                     height: 1.3,
    //                   ),
    //                   velocity: 30,
    //                   blankSpace: 120,
    //                   pauseAfterRound: const Duration(seconds: 1),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
          
    //       if (qrUrl != null && qrUrl!.isNotEmpty)
    //         Builder(
    //           builder: (context) {
    //             final screenWidth = MediaQuery.of(context).size.width;
    //             final qrSize = 35.0; // Match the container height
                
    //             return Container(
    //               width: qrSize,
    //               height: qrSize,
    //               color: const Color(0xFFCD0711), 
    //               alignment: Alignment.center,
    //               child: QrImageView(
    //                 data: qrUrl!,
    //                 version: QrVersions.auto,
    //                 size: qrSize - 4, // Slightly smaller to fit within container
    //                 backgroundColor: Colors.white, 
    //                 eyeStyle: const QrEyeStyle(
    //                   eyeShape: QrEyeShape.circle,
    //                   color: Colors.black,
    //                 ),
    //                 dataModuleStyle: const QrDataModuleStyle(
    //                   dataModuleShape: QrDataModuleShape.circle,
    //                   color: Colors.black,
    //                 ),
    //                 padding: const EdgeInsets.all(2),
    //                 errorStateBuilder: (context, error) {
    //                   return const Icon(
    //                     Icons.qr_code,
    //                     size: 30,
    //                     color: Colors.black,
    //                   );
    //                 },
    //               ),
    //             );
    //           },
    //         ),
    //     ],
    //   ),
    // );
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
                      child: Marquee(
                        text: _buildNewsText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        velocity: 30,
                        blankSpace: 120,
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
      if (qrUrl != null && qrUrl!.isNotEmpty)
        Positioned(
          // right: 8,
          // bottom: -5, // 👈 move outside bottom
           right: 0,
           top: -15, 
          child: QrImageView(
            data: qrUrl!,
            version: QrVersions.auto,
            size: 80, // 👈 BIG SIZE
            backgroundColor: Colors.white,
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
    final textStyle = TextStyle(
      color: Color(0xFFCD0711),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(text: text, style: textStyle);
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



