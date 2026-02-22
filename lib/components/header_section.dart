
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final Map<String, dynamic> orgInfo;

  const HeaderSection({Key? key, required this.orgInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;

    // // ✅ REDUCED sizes for portrait mode
    // final double logoHeight = isPortrait ? 60 : 55;
    // final double flagHeight = isPortrait ? 45 : 40;
    // final double contactBoxHeight = isPortrait ? 55 : 60;
    // final double fontSizeMain = isPortrait ? 15 : 16;
    // final double fontSizeSub = isPortrait ? 12 : 14;
 //nal double logoHeight = isPortrait ? 45 : 90;
//final double flagHeight = isPortrait ? 32 : 38;
//final double Height = isPortrait ? 32 : contactBoxHeight;
//nal double contactBoxHeight = isPortrait ? 42 : 100;
//nal double flagHeight = isPortrait ? 32 : contactBoxHeight; // ✅ अब use गर्न मिल्छ
//nal double contactBoxHeight = isPortrait ? 42 : 52;
// final double fontSizeMain = isPortrait ? 13 : 15;
// final double fontSizeSub = isPortrait ? 10 : 12;
final double contactBoxHeight = isPortrait ? 42 : 100; // ← पहिले define
final double logoHeight = isPortrait ? 45 : contactBoxHeight; // ← same height
final double flagHeight = isPortrait ? 32 : contactBoxHeight; // ← same height

final double fontSizeMain = isPortrait ? 16 : 42;
final double fontSizeSub = isPortrait ? 13 : 32;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(
       // top: 40,
        // top: isPortrait ? 30 : 0,
        top: isPortrait ? 6 : 4,
        left: screenWidth < 600 ? 8 : 16,
        right: screenWidth < 600 ? 8 : 16,
      //  bottom: isPortrait ? 2 : 4, 
      bottom: isPortrait ? 1 : 2,
      ),
      child: Row(
      //  crossAxisAlignment: CrossAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orgInfo['logo'] != null && orgInfo['logo'].toString().isNotEmpty
              ? Image.network(
                  orgInfo['logo'],
                  height: logoHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/logonepal.jpg',
                      height: logoHeight,
                    );
                  },
                )
              : Image.asset(
                  'assets/logonepal.jpg',
                  height: logoHeight,
                ),

          SizedBox(width: isPortrait ? 4 : 6), 

       
    Expanded(
  child: SizedBox(
    height: contactBoxHeight,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
                if (orgInfo['slogan'] != null &&
                    orgInfo['slogan'].toString().isNotEmpty)
                  Padding(
                   // padding: EdgeInsets.only(bottom: isPortrait ? 1 : 2), 
                   padding: EdgeInsets.only(bottom: 0),
                    child: Text(
                      orgInfo['slogan'],
                      textAlign: TextAlign.center,
                        maxLines: 1,  // ✅ ADD THIS
                    overflow: TextOverflow.ellipsis, 
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: fontSizeSub,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Text(
                  orgInfo['orgname'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFcd0711),
                    fontSize: fontSizeMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  orgInfo['orgname_np'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFcd0711),
                    fontSize: fontSizeSub,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  orgInfo['orgaddress1'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF2056ae),
                    fontSize: fontSizeSub,
                  ),
                ),
              ],
            ),
    ),
          ),
          ),
          SizedBox(width: isPortrait ? 4 : 6),
          // Contact Box + Static Flag
          SizedBox(
            height: contactBoxHeight,
            child: Row(
              children: [

                Container(
  
 // padding: EdgeInsets.all(isPortrait ? 4 : 6),
 padding: EdgeInsets.all(isPortrait ? 4 : 14),
  width: isPortrait ? null : screenWidth * 0.20,

                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EEEE),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFDBD8D8),
                      width: 1,
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _contactRow(
                          Icons.phone,
                          orgInfo['contact'] ?? '',
                          bg: Colors.red,
                          isPortrait: isPortrait, 
                           fontSize: fontSizeSub,
                        ),
                        _contactRow(
                          Icons.language,
                          orgInfo['website'] ?? '',
                          bg: Colors.blue,
                          isPortrait: isPortrait,
                           fontSize: fontSizeSub,
                        ),
                        _contactRow(
                          Icons.email,
                          orgInfo['email'] ?? '',
                          bg: Colors.green,
                          isPortrait: isPortrait,
                           fontSize: fontSizeSub,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: isPortrait ? 4 : 6), 
                Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    'assets/flag1.gif',
                    height: flagHeight,
                    width: flagHeight * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _contactRow(
    IconData icon,
    String text, {
    Color bg = Colors.grey,
    Color color = Colors.black,
    bool isPortrait = false, 
    double fontSize = 10, 
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isPortrait ? 1.0 : 2.0), 
      child: Row(
        children: [

          CircleAvatar(
  backgroundColor: bg,
  // radius: isPortrait ? 9 : 12,
  // child: Icon(icon, color: Colors.white, size: isPortrait ? 9 : 12),
//   radius: isPortrait ? 9 : 15,
// child: Icon(icon, color: Colors.white, size: isPortrait ? 9 : 15),
radius: isPortrait ? 9 : 30,
child: Icon(icon, color: Colors.white, size: isPortrait ? 9 : 28)
),
SizedBox(width: isPortrait ? 3 : 4),
Text(
  text,
  style: TextStyle(
    color: color,
 //   fontSize: isPortrait ? 10 : 12,   // ✅ FIXED
 //ntSize: isPortrait ? 10 : 16,
 //ntSize: isPortrait ? 10 : 34,
 fontSize: fontSize,
  ),
),
        ],
      ),
    );
  }
}

