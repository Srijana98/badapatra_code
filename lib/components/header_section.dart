import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final Map<String, dynamic> orgInfo;

  const HeaderSection({Key? key, required this.orgInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;

    final double logoHeight = isPortrait ? 45 : 35;
    final double flagHeight = isPortrait ? 45 : 40;
    final double contactBoxHeight = isPortrait ? 70 : 60;
    final double fontSizeMain = isPortrait ? 15 : 14;
    final double fontSizeSub = isPortrait ? 11 : 10;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 0,
        left: screenWidth < 600 ? 8 : 16,
        right: screenWidth < 600 ? 8 : 16,
        bottom: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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


          const SizedBox(width: 6),

          // Municipality / Org Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [

                if (orgInfo['slogan'] != null &&
          orgInfo['slogan'].toString().isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            orgInfo['slogan'],
            textAlign: TextAlign.center,
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
          const SizedBox(width: 6),

          // Contact Box + Static Flag
          SizedBox(
            height: contactBoxHeight,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
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
                        ),
                        _contactRow(
                          Icons.language,
                          orgInfo['website'] ?? '',
                          bg: Colors.blue,
                        ),
                        _contactRow(
                          Icons.email,
                          orgInfo['email'] ?? '',
                          bg: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bg,
            radius: 13,
            child: Icon(icon, color: Colors.white, size: 13),
          ),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}