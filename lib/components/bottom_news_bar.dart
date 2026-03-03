
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
           right: 0,
           bottom: 0,
          child:

          Positioned(
  right: 0,
  bottom: 0,
  child: SizedBox(
    width: 70,
    height: 70,
    child: QrImageView(
      data: qrUrl!,
      version: QrVersions.auto,
      gapless: true, 
      backgroundColor: Colors.white, 
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    ),
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



