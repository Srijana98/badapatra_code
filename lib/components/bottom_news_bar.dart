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
    return Container(
      height: 35,
      width: double.infinity,
    
      child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

          // News bar section
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
                    //padding: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Marquee(
                      text: _buildNewsText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        //fontWeight: FontWeight.bold,
                         fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      velocity: 30,
                      blankSpace: 120,
                      pauseAfterRound: const Duration(seconds: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // QR Code section on the right
          if (qrUrl != null && qrUrl!.isNotEmpty)
            Container(
              width: 50,
              height: 50,
              color: Colors.white,
         
             
            child  :QrImageView(
  data: qrUrl!,
  version: QrVersions.auto,
  size: 44,
  backgroundColor: Colors.white,

  eyeStyle: const QrEyeStyle(
    eyeShape: QrEyeShape.circle,
    color: Colors.black,
  ),

 
  dataModuleStyle: const QrDataModuleStyle(
    dataModuleShape: QrDataModuleShape.circle,
    color: Colors.black,
  ),

  padding: const EdgeInsets.all(2),

  errorStateBuilder: (context, error) {
    return const Icon(
      Icons.qr_code,
      size: 50,
      color: Colors.black,
    );
  },
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