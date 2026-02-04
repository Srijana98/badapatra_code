import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';


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
  

  @override
  Widget build(BuildContext context) {
    if (widget.notices.isEmpty) {
      return const SizedBox.shrink();
    }
final allNotices = widget.notices
      .map((n) => _stripHtmlTags(n['notices'] ?? ''))
      .join('   ||   ');
    return Container(
      height: 40,
      color: Color(0xFF233072),

      child: Row(
        children: [


          Container(
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  color: Colors.red.shade700,
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
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Marquee(
      text: allNotices,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      scrollAxis: Axis.horizontal,
      blankSpace: 50,
      velocity: 40,
      pauseAfterRound: Duration.zero,
      startPadding: 10,
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