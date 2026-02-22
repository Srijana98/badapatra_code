// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:nagarikbadapatra/models/service.dart';

// typedef SearchCallback = void Function(String value);
// typedef CodeTypedCallback = void Function(String code);

// // Responsive Constants
// class Responsive {
//   static const double mobileMaxWidth = 600;
//   static const double tvMinWidth = 1200;
//   static bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < mobileMaxWidth;
//   static bool isTV(BuildContext context) =>
//       MediaQuery.of(context).size.width >= tvMinWidth;
//   static double fontSize(BuildContext context, double mobile, double tv) {
//     final width = MediaQuery.of(context).size.width;
//     if (width >= tvMinWidth) return tv;
//     if (width < mobileMaxWidth) return mobile;
//     return mobile +
//         (tv - mobile) *
//             (width - mobileMaxWidth) /
//             (tvMinWidth - mobileMaxWidth);
//   }
// }

// // Colors
// final Color headerBg = const Color(0xFFE45C53);
// final Color rowBg = const Color(0xFFF9D7D7);
// final Color appBarBg = Colors.blue;
// final Color textHeader = Colors.white;
// final Color textRow = Colors.black87;

// class CustomSearchBar extends StatefulWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final VoidCallback onSearch;
//   final SearchCallback? onChanged;
//   final CodeTypedCallback? onCodeTyped;
//   final List<dynamic> badapatradata;

//   const CustomSearchBar({
//     super.key,
//     required this.controller,
//     required this.focusNode,
//     required this.onSearch,
//     required this.badapatradata,
//     this.onChanged,
//     this.onCodeTyped,

//   });

//   @override
//   _CustomSearchBarState createState() => _CustomSearchBarState();
// }

// class _CustomSearchBarState extends State<CustomSearchBar> {
//   String _typedCode = '';
//   Timer? _typingTimer;
//   Service? _lastSearchedService;


//   final List<double> columnWidthsPortrait = [80, 255, 355, 235, 215, 235, 255];
//   final List<double> columnWidthsLandscape = [70, 235, 335, 215, 195, 215, 235];

  

//   @override
//   void initState() {
//     super.initState();
//     HardwareKeyboard.instance.addHandler(_handleKeyPress);
//   }

//   @override
//   void dispose() {
//     HardwareKeyboard.instance.removeHandler(_handleKeyPress);
//     _typingTimer?.cancel();
//     super.dispose();
//   }

//   bool _handleKeyPress(KeyEvent event) {
//     if (event is KeyDownEvent) {
//       final keyChar = event.character;

//       if (event.logicalKey == LogicalKeyboardKey.numpadMultiply ||
//           keyChar == '*') {
//         widget.focusNode.requestFocus();
//         return true;
//       }

//       if (keyChar != null && RegExp(r'^[0-9]$').hasMatch(keyChar)) {
//         _typedCode += keyChar;
//         widget.controller.text = _typedCode;
//         widget.controller.selection = TextSelection.fromPosition(
//           TextPosition(offset: _typedCode.length),
//         );

//         _typingTimer?.cancel();
//         _typingTimer = Timer(const Duration(milliseconds: 1000), () async {
//           if (_typedCode.isNotEmpty) {
//             widget.onCodeTyped?.call(_typedCode);
//             final service = await _fetchServiceByCode(_typedCode);
//             if (service != null) {
//               _lastSearchedService = service;
//               if (mounted) _showFullScreenTable(context, service);
//             }
//             _typedCode = '';
//             widget.controller.clear();
//           }
//         });

//         return true;
//       }
//     }
//     return false;
//   }

//   void _showFullScreenTable(BuildContext context, Service service) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder:
//             (_) => OrientationBuilder(
//               builder: (context, orientation) {
//                 return Scaffold(
//                   appBar: AppBar(
//                     // toolbarHeight: 40, 
//                     toolbarHeight: 32,
//                     leading: IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () {
//                         Navigator.of(
//                           context,
//                         ).popUntil((route) => route.isFirst);
//                       },
//                     ),
//                     title: Text(
//                       service.serviceTypeName,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: Responsive.fontSize(context, 16, 20),
//                       //fontSize: Responsive.fontSize(context, 14, 18),
//                       ),
//                     ),
//                     backgroundColor: appBarBg,
//                     iconTheme: const IconThemeData(color: Colors.white),
//                   ),
//                   body: Container(
//                     color: rowBg,
//                     child: Column(
//                       children: [
//                         Container(
//                           color: headerBg,
//                          // padding: const EdgeInsets.symmetric(vertical: 16),
//                          // padding: const EdgeInsets.symmetric(vertical: 4),
//                          padding: const EdgeInsets.symmetric(vertical: 2),
//                           child: Row(children: _buildHeaderRow(context)),
//                         ),
//                         // Expanded(
//                         //   child: SingleChildScrollView(
//                         //     physics: const BouncingScrollPhysics(),
//                         //     child: Container(
//                         //       color: rowBg,
//                         //       padding: const EdgeInsets.all(16),
//                         //       child: Row(
//                         //         crossAxisAlignment: CrossAxisAlignment.start,
//                         //         children: _buildDataRow(context, service),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),

//                         Expanded(
//   child: Row(
//     crossAxisAlignment: CrossAxisAlignment.stretch, // ← full height
//     children: _buildDataRow(context, service),
//   ),
// ),

//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//         fullscreenDialog: true,
//       ),
//     );
//   }

//   List<Widget> _buildHeaderRow(BuildContext context) {
//     final headers = [
//       'क्र.स',
//       'सेवाको किसिम',
//       'सेवा प्राप्त गर्न पेश गर्नुपर्ने बिबरण',
//       'लाग्ने शुल्क',
//       'लाग्ने समय',
//       'सेवा दिने शाखा',
//       'गुनासो सुन्ने अधिकारी',
//     ];
//     final flexes =
//         Responsive.isTV(context)
//             ? [1, 2, 3, 2, 2, 2, 2]
//             : [1, 2, 4, 2, 2, 2, 2];

//     // return headers.asMap().entries.map((e) {
//     //   return Expanded(
//     //     flex: flexes[e.key],
//     //     child: Text(
//     //       e.value,
//     //       style: TextStyle(
//     //         color: textHeader,
//     //         fontWeight: FontWeight.bold,
//     //         fontSize: Responsive.fontSize(context, 13, 16),
//     //       ),
//     //       textAlign: TextAlign.center,
//     //     ),
//     //   );
//     // }).toList();
// return headers.asMap().entries.map((e) {
//   return Expanded(
//     flex: flexes[e.key],
//     child: Container(
//       alignment: Alignment.center,
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//       // child: Text(
//       //   e.value,
//       //   style: TextStyle(
//       //     color: textHeader,
//       //     fontWeight: FontWeight.bold,
//       //     fontSize: Responsive.fontSize(context, 12, 14),
//       //   ),
//       //   textAlign: TextAlign.center,
//       // ),
//       // AFTER:
// child: Container(
//   decoration: BoxDecoration(
//     border: Border(
//       right: e.key < headers.length - 1
//           ? const BorderSide(color: Colors.white54, width: 1)
//           : BorderSide.none,
//     ),
//   ),
//   alignment: Alignment.center,
//   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//   child: Text(
//     e.value,
//     style: TextStyle(
//       color: textHeader,
//       fontWeight: FontWeight.bold,
//       fontSize: Responsive.fontSize(context, 12, 14),
//     ),
//     textAlign: TextAlign.center,
//   ),
// ),
//     ),
//   );
// }).toList();
    
//   }

  
 

// //   List<Widget> _buildDataRow(BuildContext context, Service s) {
// //   // HTML strip helper
// //   String stripHtml(String text) {
// //     return text
// //         .replaceAll(RegExp(r'<[^>]*>'), '')
// //         .replaceAll('&nbsp;', ' ')
// //         .replaceAll('\r\n', '\n')
// //         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
// //         .trim();
// //   }

// //   final values = [
// //     s.code,
// //     s.serviceTypeName,
// //     stripHtml(s.serviceRecDetail), 
// //     s.fee,
// //     s.time,
// //     s.serviceProvider,
// //     s.complainListen,
// //   ];
// //     final flexes =
// //         Responsive.isTV(context)
// //             ? [1, 2, 3, 2, 2, 2, 2]
// //             : [1, 2, 4, 2, 2, 2, 2];

// //     // return values.asMap().entries.map((e) {
// //     //   return Expanded(
// //     //     flex: flexes[e.key],
// //     //     child: Text(
// //     //       e.value,
// //     //       style: TextStyle(
// //     //        fontSize: Responsive.fontSize(context, 13, 15),
// //     //       // fontSize: Responsive.fontSize(context, 12, 14),
// //     //         color: textRow,
// //     //       ),
// //     //       softWrap: true,
// //     //     ),
// //     //   );
// //     // }).toList();
// //     // AFTER:
// // return values.asMap().entries.map((e) {
// //   return Expanded(
// //     flex: flexes[e.key],
// //     child: Container(
// //       decoration: BoxDecoration(
// //         border: Border(
// //           right: e.key < values.length - 1
// //               ? BorderSide(color: Colors.red.shade200, width: 1)
// //               : BorderSide.none,
// //         ),
// //       ),
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       child: Text(
// //         e.value,
// //         style: TextStyle(
// //           fontSize: Responsive.fontSize(context, 13, 15),
// //           color: textRow,
// //         ),
// //         softWrap: true,
// //       ),
// //     ),
// //   );
// // }).toList();

    
// //   }

// List<Widget> _buildDataRow(BuildContext context, Service s) {
//   String stripHtml(String text) {
//     return text
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll('&nbsp;', ' ')
//         .replaceAll('\r\n', '\n')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }

//   final values = [
//     s.code,
//     s.serviceTypeName,
//     stripHtml(s.serviceRecDetail),
//     s.fee,
//     s.time,
//     s.serviceProvider,
//     s.complainListen,
//   ];

//   final flexes = Responsive.isTV(context)
//       ? [1, 2, 3, 2, 2, 2, 2]
//       : [1, 2, 4, 2, 2, 2, 2];

//   return values.asMap().entries.map((e) {
//     return Expanded(
//       flex: flexes[e.key],
//       // child: Container(
//       //   color: rowBg, // ← full height background
//       //   decoration: BoxDecoration(
//       //     border: Border(
//       //       right: e.key < values.length - 1
//       //           ? BorderSide(color: Colors.red.shade300, width: 1)
//       //           : BorderSide.none,
//       //     ),
//       //   ),
//       // AFTER:
// child: Container(
//   decoration: BoxDecoration(
//     color: rowBg,      // ✅ color लाई BoxDecoration भित्र राख्नुस्
//     border: Border(
//       right: e.key < values.length - 1
//           ? BorderSide(color: Colors.red.shade300, width: 1)
//           : BorderSide.none,
//     ),
//   ),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//         child: SingleChildScrollView( // ← content scroll गर्न मिलोस्
//           child: Text(
//             e.value,
//             style: TextStyle(
//               fontSize: Responsive.fontSize(context, 13, 15),
//               color: textRow,
//             ),
//             softWrap: true,
//           ),
//         ),
//       ),
//     );
//   }).toList();
// }

  

  

//    Service? _fetchServiceByCode(String code) {
//     try {
//       final matched = widget.badapatradata.cast<Map<String, dynamic>>().firstWhere(
//         (s) => s['code'].toString().trim() == code.trim(),
//         orElse: () => <String, dynamic>{},
//       );
      
//       if (matched.isNotEmpty) {
//         return Service.fromJson(matched);
//       }
//     } catch (e) {
//       debugPrint('Service search error: $e');
//     }
//     return null;
//   }



//   @override
//   Widget build(BuildContext context) {
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;

//     // Calculate total table width to match
//     final columnWidths =
//         isPortrait ? columnWidthsPortrait : columnWidthsLandscape;
//     final totalTableWidth = columnWidths.reduce((a, b) => a + b);

//     final height = Responsive.isTV(context) ? 40.0 : 30.0;

//     return Container(
//   width: double.infinity,
//       height: height,
//       margin: const EdgeInsets.only(top: 1),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(Responsive.isTV(context) ? 16 : 12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: Responsive.isTV(context) ? 4 : 3,
//             offset: Offset(0, Responsive.isTV(context) ? 2 : 1.5),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: widget.controller,
//         focusNode: widget.focusNode,
//         keyboardType: TextInputType.number,
//         inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9*]'))],
//         onChanged: widget.onChanged,
//         onSubmitted: (_) => widget.onSearch(),
//         style: TextStyle(fontSize: Responsive.fontSize(context, 12, 16)),
//         decoration: InputDecoration(
//           hintText: "(*) थिच्नुहोस् र नं. टाइप गर्नुहोस्",
//           hintStyle: TextStyle(
//             color: Colors.blue,
//             fontSize: Responsive.fontSize(context, 10, 14),
//           ),
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: Responsive.isTV(context) ? 16 : 10,

//             vertical: Responsive.isTV(context) ? 10 : 6,
//           ),
//           border: InputBorder.none,
//           isDense: true,
//           suffixIcon: IconButton(
//             icon: Icon(
//               Icons.search,
//               size: Responsive.isTV(context) ? 24 : 16,
//               color: Colors.blue,
//             ),
//             onPressed: widget.onSearch,
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nagarikbadapatra/models/service.dart';

typedef SearchCallback = void Function(String value);
typedef CodeTypedCallback = void Function(String code);

// Responsive Constants
class Responsive {
  static const double mobileMaxWidth = 600;
  static const double tvMinWidth = 1200;
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;
  static bool isTV(BuildContext context) =>
      MediaQuery.of(context).size.width >= tvMinWidth;
  static double fontSize(BuildContext context, double mobile, double tv) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tvMinWidth) return tv;
    if (width < mobileMaxWidth) return mobile;
    return mobile +
        (tv - mobile) *
            (width - mobileMaxWidth) /
            (tvMinWidth - mobileMaxWidth);
  }
}

// Colors
final Color headerBg = const Color(0xFFE45C53);
final Color rowBg = const Color(0xFFF9D7D7);
final Color appBarBg = Colors.blue;
final Color textHeader = Colors.white;
final Color textRow = Colors.black87;

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSearch;
  final SearchCallback? onChanged;
  final CodeTypedCallback? onCodeTyped;
  final List<dynamic> badapatradata;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSearch,
    required this.badapatradata,
    this.onChanged,
    this.onCodeTyped,
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  String _typedCode = '';
  Timer? _typingTimer;
  Service? _lastSearchedService;

  final List<double> columnWidthsPortrait = [80, 255, 355, 235, 215, 235, 255];
  final List<double> columnWidthsLandscape = [70, 235, 335, 215, 195, 215, 235];

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyPress);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyPress);
    _typingTimer?.cancel();
    super.dispose();
  }

  bool _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      final keyChar = event.character;

      if (event.logicalKey == LogicalKeyboardKey.numpadMultiply ||
          keyChar == '*') {
        widget.focusNode.requestFocus();
        return true;
      }

      if (keyChar != null && RegExp(r'^[0-9]$').hasMatch(keyChar)) {
        _typedCode += keyChar;
        widget.controller.text = _typedCode;
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _typedCode.length),
        );

        _typingTimer?.cancel();
        _typingTimer = Timer(const Duration(milliseconds: 1000), () async {
          if (_typedCode.isNotEmpty) {
            widget.onCodeTyped?.call(_typedCode);
            final service = _fetchServiceByCode(_typedCode);
            if (service != null) {
              _lastSearchedService = service;
              if (mounted) _showFullScreenTable(context, service);
            }
            _typedCode = '';
            widget.controller.clear();
          }
        });

        return true;
      }
    }
    return false;
  }

  void _showFullScreenTable(BuildContext context, Service service) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrientationBuilder(
          builder: (context, orientation) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 32,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                title: Text(
                  service.serviceTypeName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.fontSize(context, 16, 20),
                  ),
                ),
                backgroundColor: appBarBg,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Column(
                children: [
                  // Header Row
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildHeaderRow(context),
                    ),
                  ),
                  // Data Row - full height
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildDataRow(context, service),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  List<Widget> _buildHeaderRow(BuildContext context) {
    final headers = [
      'क्र.स',
      'सेवाको किसिम',
      'सेवा प्राप्त गर्न पेश गर्नुपर्ने बिबरण',
      'लाग्ने शुल्क',
      'लाग्ने समय',
      'सेवा दिने शाखा',
      'गुनासो सुन्ने अधिकारी',
    ];
    final flexes = Responsive.isTV(context)
        ? [1, 2, 3, 2, 2, 2, 2]
        : [1, 2, 4, 2, 2, 2, 2];

    return headers.asMap().entries.map((e) {
      return Expanded(
        flex: flexes[e.key],
        child: Container(
          decoration: BoxDecoration(
            color: headerBg,
            border: Border(
              right: e.key < headers.length - 1
                 // const BorderSide(color: Colors.white54, width: 1)
                 ? const BorderSide(color: Colors.white12,width:1)
                  : BorderSide.none,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          alignment: Alignment.center,
          child: Text(
            e.value,
            style: TextStyle(
              color: textHeader,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.fontSize(context, 12, 14),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildDataRow(BuildContext context, Service s) {
    String stripHtml(String text) {
      return text
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('\r\n', '\n')
          .replaceAll(RegExp(r'\n{3,}'), '\n\n')
          .trim();
    }

    final values = [
      s.code,
      s.serviceTypeName,
      stripHtml(s.serviceRecDetail),
      s.fee,
      s.time,
      s.serviceProvider,
      s.complainListen,
    ];

    final flexes = Responsive.isTV(context)
        ? [1, 2, 3, 2, 2, 2, 2]
        : [1, 2, 4, 2, 2, 2, 2];

    return values.asMap().entries.map((e) {
      return Expanded(
        flex: flexes[e.key],
        child: Container(
          decoration: BoxDecoration(
            color: rowBg,
            border: Border(
              right: e.key < values.length - 1
                 // BorderSide(color: Colors.red.shade200, width: 1)
                 // BorderSide(color: Colors.red.shade50,width:1)
                 ? BorderSide(color: Colors.red.withOpacity(0.12), width: 1)
                  : BorderSide.none,
            ),
          ),
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              e.value,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 13, 15),
                color: textRow,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Service? _fetchServiceByCode(String code) {
    try {
      final matched =
          widget.badapatradata.cast<Map<String, dynamic>>().firstWhere(
                (s) => s['code'].toString().trim() == code.trim(),
                orElse: () => <String, dynamic>{},
              );

      if (matched.isNotEmpty) {
        return Service.fromJson(matched);
      }
    } catch (e) {
      debugPrint('Service search error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final columnWidths =
        isPortrait ? columnWidthsPortrait : columnWidthsLandscape;
    final totalTableWidth = columnWidths.reduce((a, b) => a + b);

    final height = Responsive.isTV(context) ? 40.0 : 30.0;

    return Container(
      width: double.infinity,
      height: height,
      margin: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(Responsive.isTV(context) ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: Responsive.isTV(context) ? 4 : 3,
            offset: Offset(0, Responsive.isTV(context) ? 2 : 1.5),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9*]'))
        ],
        onChanged: widget.onChanged,
        onSubmitted: (_) => widget.onSearch(),
        style: TextStyle(fontSize: Responsive.fontSize(context, 12, 16)),
        decoration: InputDecoration(
          hintText: "(*) थिच्नुहोस् र नं. टाइप गर्नुहोस्",
          hintStyle: TextStyle(
            color: Colors.blue,
            fontSize: Responsive.fontSize(context, 10, 14),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Responsive.isTV(context) ? 16 : 10,
            vertical: Responsive.isTV(context) ? 10 : 6,
          ),
          border: InputBorder.none,
          isDense: true,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              size: Responsive.isTV(context) ? 24 : 16,
              color: Colors.blue,
            ),
            onPressed: widget.onSearch,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ),
    );
  }
}