
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../login_page.dart';

// class HeaderSection extends StatelessWidget {
//   final Map<String, dynamic> orgInfo;
//   final VoidCallback? onLogout;

//   const HeaderSection({Key? key,
//    required this.orgInfo,
//    this.onLogout, 
//    }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isPortrait =
//     MediaQuery.of(context).orientation == Orientation.portrait;
//     final screenWidth = MediaQuery.of(context).size.width;

// final double contactBoxHeight = isPortrait ? 42 : 100; 
// final double logoHeight = isPortrait ? 45 : contactBoxHeight; 
// final double flagHeight = isPortrait ? 32 : contactBoxHeight; 

// final double fontSizeMain = isPortrait ? 16 : 42;
// //final double fontSizeSub = isPortrait ? 13 : 32;
// final double fontSizeSub = isPortrait ? 18 : 40; 

//     return Container(
//       width: double.infinity,
//       color: Colors.white,
//       padding: EdgeInsets.only(
       
//         top: isPortrait ? 6 : 4,
//         left: screenWidth < 600 ? 8 : 16,
//         right: screenWidth < 600 ? 8 : 16,
   
//       bottom: isPortrait ? 1 : 2,
//       ),
//       child: Row(
    
//       crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           orgInfo['logo'] != null && orgInfo['logo'].toString().isNotEmpty
//               ? Image.network(
//                   orgInfo['logo'],
//                   height: logoHeight,
//                   fit: BoxFit.contain,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Image.asset(
//                       'assets/logonepal.jpg',
//                       height: logoHeight,
//                     );
//                   },
//                 )
//               : Image.asset(
//                   'assets/logonepal.jpg',
//                   height: logoHeight,
//                 ),

//           SizedBox(width: isPortrait ? 4 : 6), 

       
//     Expanded(
//   child: SizedBox(
//     height: contactBoxHeight,
//     child: FittedBox(
//       fit: BoxFit.scaleDown,
//       alignment: Alignment.center,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//                 if (orgInfo['header_slogan'] != null &&
//                     orgInfo['header_slogan'].toString().isNotEmpty)
//                   Padding(
//                    // padding: EdgeInsets.only(bottom: isPortrait ? 1 : 2), 
//                    padding: EdgeInsets.only(bottom: 0),
//                     child: Text(
//                        orgInfo['header_slogan'],
//                       textAlign: TextAlign.center,
//                         maxLines: 1,  // ✅ ADD THIS
//                     overflow: TextOverflow.ellipsis, 
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontSize: fontSizeSub,
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 Text(
//                   orgInfo['header_text1'] ?? '',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: const Color(0xFFcd0711),
//                     fontSize: fontSizeMain,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   orgInfo['header_text2'] ?? '',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: const Color(0xFFcd0711),
//                     fontSize: fontSizeSub,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   orgInfo['header_text3'] ?? '',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: const Color(0xFF2056ae),
//                     fontSize: fontSizeSub,
//                   ),
//                 ),
//               ],
//             ),
//     ),
//           ),
//           ),
//           SizedBox(width: isPortrait ? 4 : 6),
//           // Contact Box + Static Flag
//           SizedBox(
//             height: contactBoxHeight,
//             child: Row(
//               children: [

//                 Container(
  
 
//  padding: EdgeInsets.all(isPortrait ? 4 : 14),
//   width: isPortrait ? null : screenWidth * 0.20,

//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF1EEEE),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: const Color(0xFFDBD8D8),
//                       width: 1,
//                     ),
//                   ),
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     alignment: Alignment.centerLeft,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         _contactRow(
//                           Icons.phone,
//                           orgInfo['contact'] ?? '',
//                           bg: Colors.red,
//                           isPortrait: isPortrait, 
//                            fontSize: fontSizeSub,
//                         ),
//                         _contactRow(
//                           Icons.language,
//                           orgInfo['website'] ?? '',
//                           bg: Colors.blue,
//                           isPortrait: isPortrait,
//                            fontSize: fontSizeSub,
//                         ),
//                         _contactRow(
//                           Icons.email,
//                           orgInfo['email'] ?? '',
//                           bg: Colors.green,
//                           isPortrait: isPortrait,
//                            fontSize: fontSizeSub,
//                         ),

// GestureDetector(
//   onTap: () async {
//     const storage = FlutterSecureStorage();
//     await storage.deleteAll();

//     final prefs = await SharedPreferences.getInstance();
//     final rememberMe = prefs.getBool('remember_me') ?? false;

//     // ✅ Only clear credentials if Remember Me is NOT enabled
//     if (!rememberMe) {
//       await prefs.remove('saved_username');
//       await prefs.remove('saved_password');
//     }

//     // ✅ Do NOT touch 'remember_me' key itself on logout

//     if (context.mounted) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//         (route) => false,
//       );
//     }
//   },
//   child: _contactRow(
//     Icons.logout,
//     'Logout',
//     bg: Colors.blue,
//     color: Colors.blue,
//     isPortrait: isPortrait,
//     fontSize: fontSizeSub,
//     underline: true,
//   ),
// ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: isPortrait ? 4 : 6), 
//                 Opacity(
//                   opacity: 0.6,
//                   child: Image.asset(
//                     'assets/flag1.gif',
//                     height: flagHeight,
//                     width: flagHeight * 0.7,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static Widget _contactRow(
//     IconData icon,
//     String text, {
//     Color bg = Colors.grey,
//     Color color = Colors.black,
//     bool isPortrait = false, 
//     double fontSize = 10, 
//      bool underline = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isPortrait ? 1.0 : 2.0), 
//       child: Row(
//         children: [

//           CircleAvatar(
//   backgroundColor: bg,
  
// //radius: isPortrait ? 9 : 30,
//  radius: isPortrait ? 15 : 40,    
// //child: Icon(icon, color: Colors.white, size: isPortrait ? 9 : 28)
// child: Icon(icon, color: Colors.white, size: isPortrait ? 15 : 40),
// ),
// SizedBox(width: isPortrait ? 3 : 4),
// Text(
//   text,
//   style: TextStyle(
//     color: color,
//  fontSize: fontSize,
//  decoration: underline ? TextDecoration.underline : TextDecoration.none,
//     decorationColor: color,
//   ),
// ),
//         ],
//       ),
//     );
//   }
// }








// code to handle the date and time container

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'dart:math';
// import 'package:intl/intl.dart';
// import '../login_page.dart'; 
// import 'package:nepali_utils/nepali_utils.dart';

// class HeaderSection extends StatefulWidget {
//   final Map<String, dynamic> orgInfo;
//   final VoidCallback? onLogout;

//   const HeaderSection({
//     Key? key,
//     required this.orgInfo,
//     this.onLogout,
//   }) : super(key: key);

//   @override
//   State<HeaderSection> createState() => _HeaderSectionState();
// }

// class _HeaderSectionState extends State<HeaderSection> {
//   late Timer _timer;
//   DateTime _currentTime = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     // Update time every second for the live clock
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           _currentTime = DateTime.now();
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

  
//   String _getNepaliWeekday(int weekday) {
//     switch (weekday) {
//       case 1: return 'सोमबार';
//       case 2: return 'मंगलबार';
//       case 3: return 'बुधबार';
//       case 4: return 'बिहीबार';
//       case 5: return 'शुक्रबार';
//       case 6: return 'शनिबार';
//       case 7: return 'आइतबार';
//       default: return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//     final screenWidth = MediaQuery.of(context).size.width;

//     final double contactBoxHeight = isPortrait ? 42 : 100;
//     final double logoHeight = isPortrait ? 45 : contactBoxHeight;

//     final double fontSizeMain = isPortrait ? 16 : 42;
//     final double fontSizeSub = isPortrait ? 18 : 40;

//     return Container(
//       width: double.infinity,
//       color: Colors.white,
//       padding: EdgeInsets.only(
//         top: isPortrait ? 6 : 4,
//         left: screenWidth < 600 ? 8 : 16,
//         right: screenWidth < 600 ? 8 : 16,
//         bottom: isPortrait ? 1 : 2,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // ── 1. Logo ──
//           widget.orgInfo['logo'] != null &&
//                   widget.orgInfo['logo'].toString().isNotEmpty
//               ? Image.network(
//                   widget.orgInfo['logo'],
//                   height: logoHeight,
//                   fit: BoxFit.contain,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Image.asset(
//                       'assets/logonepal.jpg',
//                       height: logoHeight,
//                     );
//                   },
//                 )
//               : Image.asset(
//                   'assets/logonepal.jpg',
//                   height: logoHeight,
//                 ),

//           SizedBox(width: isPortrait ? 4 : 6),

//           // ── 2. Center Text ──
//           Expanded(
//             child: SizedBox(
//               height: contactBoxHeight,
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 alignment: Alignment.center,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (widget.orgInfo['header_slogan'] != null &&
//                         widget.orgInfo['header_slogan'].toString().isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 0),
//                         child: Text(
//                           widget.orgInfo['header_slogan'],
//                           textAlign: TextAlign.center,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: fontSizeSub,
//                             fontStyle: FontStyle.italic,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     Text(
//                       widget.orgInfo['header_text1'] ?? '',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: const Color(0xFFcd0711),
//                         fontSize: fontSizeMain,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       widget.orgInfo['header_text2'] ?? '',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: const Color(0xFFcd0711),
//                         fontSize: fontSizeSub,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       widget.orgInfo['header_text3'] ?? '',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: const Color(0xFF2056ae),
//                         fontSize: fontSizeSub,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(width: isPortrait ? 4 : 16),

//           if (!isPortrait || screenWidth > 600) 
//             _buildDateTimeSection(contactBoxHeight),

//           SizedBox(width: isPortrait ? 4 : 16),

//           // ── 4. Right Side: Contact Info + Flag ──
//           SizedBox(
//             height: contactBoxHeight,
//             child: Stack(
//               alignment: Alignment.centerRight,
//               children: [
//                 Positioned(
//                   right: 0,
//                   child: Opacity(
//                     opacity: 0.25,
//                     child: Image.asset(
//                       'assets/flag1.gif',
//                       height: contactBoxHeight,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   alignment: Alignment.centerLeft,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _contactRow(
//                         Icons.phone,
//                         widget.orgInfo['contact'] ?? '',
//                         bg: const Color(0xFF005500),
//                         color: const Color(0xFF005500),
//                         isPortrait: isPortrait,
//                         fontSize: fontSizeSub,
//                       ),
//                       _contactRow(
//                         Icons.language,
//                         widget.orgInfo['website'] ?? '',
//                         bg: const Color(0xFF005500),
//                         color: const Color(0xFF005500),
//                         isPortrait: isPortrait,
//                         fontSize: fontSizeSub,
//                       ),
//                       _contactRow(
//                         Icons.email,
//                         widget.orgInfo['email'] ?? '',
//                         bg: const Color(0xFF005500),
//                         color: const Color(0xFF005500),
//                         isPortrait: isPortrait,
//                         fontSize: fontSizeSub,
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           const storage = FlutterSecureStorage();
//                           await storage.deleteAll();

//                           final prefs = await SharedPreferences.getInstance();
//                           final rememberMe =
//                               prefs.getBool('remember_me') ?? false;

//                           if (!rememberMe) {
//                             await prefs.remove('saved_username');
//                             await prefs.remove('saved_password');
//                           }

//                           if (context.mounted) {
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const LoginPage()),
//                               (route) => false,
//                             );
//                           }
//                         },
//                         child: _contactRow(
//                           Icons.logout,
//                           'Logout',
//                           bg: Colors.blue,
//                           color: Colors.blue,
//                           isPortrait: isPortrait,
//                           fontSize: fontSizeSub,
//                           underline: true,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateTimeSection(double height) {
//     final boxHeight = height * 0.9; 
//    // final boxColor = const Color(0xFF6C81A6); 

//     NepaliDateTime nepaliTime = NepaliDateTime.fromDateTime(_currentTime);

//     String monthYear = NepaliDateFormat('MMMM yyyy', Language.nepali).format(nepaliTime);
//     String day = NepaliDateFormat('dd', Language.nepali).format(nepaliTime);
    
//     // ── UPDATED HERE: Using our custom helper function ──
//     String weekday = _getNepaliWeekday(_currentTime.weekday); 
    
//     String timeString = DateFormat('hh:mm a').format(_currentTime);

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Clock Box
//         Container(
//           height: boxHeight,
//           width: boxHeight,

//           decoration: BoxDecoration(
//   gradient: const LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [
//       Color(0xFF6B73A3), 
//       Color(0xFF8B94C4), // #8b94c4
//     ],
//   ),
//   borderRadius: BorderRadius.circular(12),
// ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: boxHeight * 0.6,
//                 width: boxHeight * 0.6,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 child: CustomPaint(
//                   painter: ClockPainter(_currentTime),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 timeString,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: boxHeight * 0.12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 8),
//         // Date Box
//         Container(
//           height: boxHeight,
//           width: boxHeight * 1.1,


//           decoration: BoxDecoration(
//   gradient: const LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [
//       Color(0xFF3F5AA6), 
//       Color(0xFF5A7BC4), 
//     ],
//   ),
//   borderRadius: BorderRadius.circular(12),
// ),
//           padding: const EdgeInsets.symmetric(vertical: 4),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 monthYear, 
//                 style: TextStyle(color: Colors.white, fontSize: boxHeight * 0.14),
//               ),
//               Text(
//                 day, 
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: boxHeight * 0.4,
//                   fontWeight: FontWeight.bold,
//                   height: 1.0,
//                 ),
//               ),
//               Text(
//                 weekday, 
//                 style: TextStyle(color: Colors.white, fontSize: boxHeight * 0.14),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   static Widget _contactRow(
//     IconData icon,
//     String text, {
//     Color bg = Colors.grey,
//     Color color = Colors.black,
//     bool isPortrait = false,
//     double fontSize = 10,
//     bool underline = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isPortrait ? 1.0 : 2.0),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: bg,
//             size: isPortrait ? 20 : 50,
//           ),
//           SizedBox(width: isPortrait ? 3 : 4),
//           Text(
//             text,
//             style: TextStyle(
//               color: color,
//               fontSize: fontSize,
//               decoration:
//                   underline ? TextDecoration.underline : TextDecoration.none,
//               decorationColor: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Custom Painter for the Analog Clock ──
// class ClockPainter extends CustomPainter {
//   final DateTime dateTime;

//   ClockPainter(this.dateTime);

//   @override
//   void paint(Canvas canvas, Size size) {
//     double centerX = size.width / 2;
//     double centerY = size.height / 2;
//     Offset center = Offset(centerX, centerY);
//     double radius = min(centerX, centerY);

//     Paint hourPaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = radius * 0.15
//       ..strokeCap = StrokeCap.round;

//     Paint minutePaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = radius * 0.1
//       ..strokeCap = StrokeCap.round;

//     Paint secondPaint = Paint()
//       ..color = Colors.red
//       ..strokeWidth = radius * 0.05
//       ..strokeCap = StrokeCap.round;

//     Paint centerDotPaint = Paint()..color = Colors.black;

//     // Draw clock numbers/ticks
//     Paint tickPaint = Paint()
//       ..color = Colors.grey
//       ..strokeWidth = 2;
//     for (int i = 0; i < 4; i++) {
//       double angle = i * pi / 2;
//       double startX = centerX + cos(angle) * (radius * 0.8);
//       double startY = centerY + sin(angle) * (radius * 0.8);
//       double endX = centerX + cos(angle) * radius;
//       double endY = centerY + sin(angle) * radius;
//       canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
//     }

//     // Calculate angles
//     double secAngle = (dateTime.second * 6) * pi / 180;
//     double minAngle = (dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180;
//     double hourAngle =
//         ((dateTime.hour % 12) * 30 + dateTime.minute * 0.5) * pi / 180;

//     // Draw Hands (Offset by -pi/2 so 12 o'clock is at the top)
//     Offset secHand = Offset(
//       centerX + cos(secAngle - pi / 2) * (radius * 0.8),
//       centerY + sin(secAngle - pi / 2) * (radius * 0.8),
//     );
//     Offset minHand = Offset(
//       centerX + cos(minAngle - pi / 2) * (radius * 0.7),
//       centerY + sin(minAngle - pi / 2) * (radius * 0.7),
//     );
//     Offset hourHand = Offset(
//       centerX + cos(hourAngle - pi / 2) * (radius * 0.5),
//       centerY + sin(hourAngle - pi / 2) * (radius * 0.5),
//     );

//     canvas.drawLine(center, hourHand, hourPaint);
//     canvas.drawLine(center, minHand, minutePaint);
//     canvas.drawLine(center, secHand, secondPaint);
//     canvas.drawCircle(center, radius * 0.1, centerDotPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }


// responsive code for both the mobile and TV
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import '../login_page.dart';
import 'package:nepali_utils/nepali_utils.dart';

class HeaderSection extends StatefulWidget {
  final Map<String, dynamic> orgInfo;
  final VoidCallback? onLogout;

  const HeaderSection({
    Key? key,
    required this.orgInfo,
    this.onLogout,
  }) : super(key: key);

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getNepaliWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'सोमबार';
      case 2: return 'मंगलबार';
      case 3: return 'बुधबार';
      case 4: return 'बिहीबार';
      case 5: return 'शुक्रबार';
      case 6: return 'शनिबार';
      case 7: return 'आइतबार';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;

    // ── KEY FIX: Use LayoutBuilder so we know the actual available width ──
    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;

      // Responsive sizing based on actual width
      final bool isTV = availableWidth > 900;
      final bool isTablet = availableWidth > 600;

      // Heights scale with available width
      final double contactBoxHeight = isTV ? 110 : (isTablet ? 70 : 44);
      final double logoHeight = contactBoxHeight;

      // ── KEY FIX: Clock/date box gets a FIXED width budget ──
      // This prevents it from stealing space from the center Expanded widget
      final double clockBoxSize = contactBoxHeight * 0.9;
      final double dateBoxWidth = clockBoxSize * 1.1;
      final double dateTimeWidth = clockBoxSize + 8 + dateBoxWidth; // clock + gap + date

      return Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.only(
          top: isTV ? 6 : 4,
          left: isTablet ? 16 : 8,
          right: isTablet ? 16 : 8,
          bottom: isTV ? 4 : 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── 1. Logo (fixed size) ──
            SizedBox(
              height: logoHeight,
              child: widget.orgInfo['logo'] != null &&
                      widget.orgInfo['logo'].toString().isNotEmpty
                  ? Image.network(
                      widget.orgInfo['logo'],
                      height: logoHeight,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/logonepal.jpg',
                        height: logoHeight,
                      ),
                    )
                  : Image.asset('assets/logonepal.jpg', height: logoHeight),
            ),

            SizedBox(width: isTablet ? 8 : 4),

            // ── 2. Center Text — Expanded so it takes ALL remaining space ──
            Expanded(
              child: SizedBox(
                height: contactBoxHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.orgInfo['header_slogan'] != null &&
                        widget.orgInfo['header_slogan'].toString().isNotEmpty)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.orgInfo['header_slogan'],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black87,
                            // ── KEY FIX: Large base font; FittedBox only shrinks if needed ──
                            fontSize: isTV ? 38 : (isTablet ? 22 : 13),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.orgInfo['header_text1'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFcd0711),
                            fontSize: isTV ? 44 : (isTablet ? 26 : 15),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.orgInfo['header_text2'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFcd0711),
                            fontSize: isTV ? 40 : (isTablet ? 24 : 14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.orgInfo['header_text3'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF2056ae),
                            fontSize: isTV ? 38 : (isTablet ? 22 : 13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: isTablet ? 12 : 4),

            // ── 3. Date/Time — FIXED width, does NOT grow ──
            if (!isPortrait || availableWidth > 600)
              SizedBox(
                width: dateTimeWidth,
                child: _buildDateTimeSection(contactBoxHeight),
              ),

            SizedBox(width: isTablet ? 12 : 4),

            // ── 4. Contact Info + Flag ──
            SizedBox(
              height: contactBoxHeight,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Positioned(
                    right: 0,
                    child: Opacity(
                      opacity: 0.25,
                      child: Image.asset(
                        'assets/flag1.gif',
                        height: contactBoxHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _contactRow(
                          Icons.phone,
                          widget.orgInfo['contact'] ?? '',
                          bg: const Color(0xFF005500),
                          color: const Color(0xFF005500),
                          isTV: isTV,
                          isTablet: isTablet,
                        ),
                        _contactRow(
                          Icons.language,
                          widget.orgInfo['website'] ?? '',
                          bg: const Color(0xFF005500),
                          color: const Color(0xFF005500),
                          isTV: isTV,
                          isTablet: isTablet,
                        ),
                        _contactRow(
                          Icons.email,
                          widget.orgInfo['email'] ?? '',
                          bg: const Color(0xFF005500),
                          color: const Color(0xFF005500),
                          isTV: isTV,
                          isTablet: isTablet,
                        ),
                        GestureDetector(
                          onTap: () async {
                            const storage = FlutterSecureStorage();
                            await storage.deleteAll();
                            final prefs = await SharedPreferences.getInstance();
                            final rememberMe =
                                prefs.getBool('remember_me') ?? false;
                            if (!rememberMe) {
                              await prefs.remove('saved_username');
                              await prefs.remove('saved_password');
                            }
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                                (route) => false,
                              );
                            }
                          },
                          child: _contactRow(
                            Icons.logout,
                            'Logout',
                            bg: Colors.blue,
                            color: Colors.blue,
                            isTV: isTV,
                            isTablet: isTablet,
                            underline: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDateTimeSection(double height) {
    final boxHeight = height * 0.9;

    NepaliDateTime nepaliTime = NepaliDateTime.fromDateTime(_currentTime);
    String monthYear = NepaliDateFormat('MMMM yyyy', Language.nepali).format(nepaliTime);
    String day = NepaliDateFormat('dd', Language.nepali).format(nepaliTime);
    String weekday = _getNepaliWeekday(_currentTime.weekday);
    String timeString = DateFormat('hh:mm a').format(_currentTime);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clock Box
        Container(
          height: boxHeight,
          width: boxHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6B73A3), Color(0xFF8B94C4)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: boxHeight * 0.6,
                width: boxHeight * 0.6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CustomPaint(painter: ClockPainter(_currentTime)),
              ),
              const SizedBox(height: 4),
              Text(
                timeString,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: boxHeight * 0.12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Date Box
        Container(
          height: boxHeight,
          width: boxHeight * 1.1,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3F5AA6), Color(0xFF5A7BC4)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(monthYear,
                  style: TextStyle(color: Colors.white, fontSize: boxHeight * 0.14)),
              Text(
                day,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: boxHeight * 0.4,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              Text(weekday,
                  style: TextStyle(color: Colors.white, fontSize: boxHeight * 0.14)),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _contactRow(
    IconData icon,
    String text, {
    Color bg = Colors.grey,
    Color color = Colors.black,
    bool isTV = false,
    bool isTablet = false,
    bool underline = false,
  }) {
    final double iconSize = isTV ? 52 : (isTablet ? 28 : 16);
    final double fontSize = isTV ? 38 : (isTablet ? 20 : 11);

    return Padding(
      padding: EdgeInsets.only(bottom: isTV ? 4.0 : 2.0),
      child: Row(
        children: [
          Icon(icon, color: bg, size: iconSize),
          SizedBox(width: isTV ? 6 : 3),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              decoration: underline ? TextDecoration.underline : TextDecoration.none,
              decorationColor: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom Painter for the Analog Clock (unchanged) ──
class ClockPainter extends CustomPainter {
  final DateTime dateTime;
  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);

    Paint hourPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = radius * 0.15
      ..strokeCap = StrokeCap.round;
    Paint minutePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = radius * 0.1
      ..strokeCap = StrokeCap.round;
    Paint secondPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = radius * 0.05
      ..strokeCap = StrokeCap.round;
    Paint centerDotPaint = Paint()..color = Colors.black;
    Paint tickPaint = Paint()..color = Colors.grey..strokeWidth = 2;

    for (int i = 0; i < 4; i++) {
      double angle = i * pi / 2;
      canvas.drawLine(
        Offset(centerX + cos(angle) * (radius * 0.8), centerY + sin(angle) * (radius * 0.8)),
        Offset(centerX + cos(angle) * radius, centerY + sin(angle) * radius),
        tickPaint,
      );
    }

    double secAngle = (dateTime.second * 6) * pi / 180;
    double minAngle = (dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180;
    double hourAngle = ((dateTime.hour % 12) * 30 + dateTime.minute * 0.5) * pi / 180;

    canvas.drawLine(center,
      Offset(centerX + cos(hourAngle - pi / 2) * (radius * 0.5),
             centerY + sin(hourAngle - pi / 2) * (radius * 0.5)), hourPaint);
    canvas.drawLine(center,
      Offset(centerX + cos(minAngle - pi / 2) * (radius * 0.7),
             centerY + sin(minAngle - pi / 2) * (radius * 0.7)), minutePaint);
    canvas.drawLine(center,
      Offset(centerX + cos(secAngle - pi / 2) * (radius * 0.8),
             centerY + sin(secAngle - pi / 2) * (radius * 0.8)), secondPaint);
    canvas.drawCircle(center, radius * 0.1, centerDotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


