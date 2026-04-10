
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

String toNepaliNumber(String input) {
  const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const nepaliDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  String output = input;
  for (int i = 0; i < englishDigits.length; i++) {
    output = output.replaceAll(englishDigits[i], nepaliDigits[i]);
  }
  return output;
}

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
  late FocusNode _keyboardFocusNode;
  Timer? _debounceTimer;
  
  // Add this flag to track if we're currently showing a popup
  bool _isShowingPopup = false;
  
  final List<double> columnWidthsPortrait = [80, 255, 355, 235, 215, 235, 255];
  final List<double> columnWidthsLandscape = [70, 235, 335, 215, 195, 215, 235];
  
  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode();
    HardwareKeyboard.instance.addHandler(_handleKeyPress);
    
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final width = MediaQuery.of(context).size.width;
          if (width >= Responsive.tvMinWidth) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    HardwareKeyboard.instance.removeHandler(_handleKeyPress);
    _keyboardFocusNode.dispose();
    super.dispose();
  }
  
  // Separate method to handle the search after typing stops
  void _performSearchAfterDelay(String code) {
    _debounceTimer?.cancel();
    
    // Only start timer if we're not showing a popup
    if (!_isShowingPopup) {
      _debounceTimer = Timer(const Duration(milliseconds: 800), () {
        if (mounted && !_isShowingPopup && code.isNotEmpty) {
          widget.onCodeTyped?.call(code);
          
          final service = _fetchServiceByCode(code);


          if (service != null && mounted) {
            debugPrint('Service found for code: $code');
            _isShowingPopup = true;
            _showFullScreenTable(context, service);
            // _typedCode = '';
            // widget.controller.clear();
            // _isShowingPopup = false;
          } else {
            debugPrint('No service found for code: $code');
            if (mounted) {
              _typedCode = '';
              widget.controller.clear();
              widget.onSearch(); 
            }
          }
        }
      });
    }
  }
  
  bool _handleKeyPress(KeyEvent event) {
    debugPrint('Key pressed: ${event.logicalKey}');
    debugPrint('Character: ${event.character}');
    
    if (event is KeyDownEvent) {
      final keyChar = event.character;
      debugPrint('KeyDownEvent detected, char: $keyChar');
      
      // ── * थिच्दा: सबै screen pop गरेर search bar focus गर्ने ──
      if (event.logicalKey == LogicalKeyboardKey.numpadMultiply ||
          event.logicalKey == LogicalKeyboardKey.asterisk ||
          keyChar == '*') {
        debugPrint('Asterisk detected! Clearing and focusing...');
        
        // Cancel any pending timer
        _debounceTimer?.cancel();
        
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.popUntil((route) => route.isFirst);
        }
        
        _typedCode = '';
        widget.controller.clear();
        widget.focusNode.requestFocus();
        _keyboardFocusNode.requestFocus();
         widget.onSearch(); 
        return true;
      }
      
      // Handle numeric input
      if (keyChar != null && RegExp(r'^[0-9]$').hasMatch(keyChar)) {
        debugPrint('Number detected: $keyChar');
        debugPrint('Current typed code: $_typedCode');
        _typedCode += keyChar;
        widget.controller.text = _typedCode;
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _typedCode.length),
        );
        
        // Call the delayed search method
        _performSearchAfterDelay(_typedCode);
        
        return true;
      }
    }
    return false;
  }


  void _showFullScreenTable(BuildContext context, Service service) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, 
        transitionDuration: Duration.zero, 
        reverseTransitionDuration: Duration.zero, 
        pageBuilder: (context, animation, secondaryAnimation) => OrientationBuilder(
          builder: (context, orientation) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 32,
                automaticallyImplyLeading: false,
                title: Text(
                  service.serviceTypeName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.fontSize(context, 16, 20),
                  ),
                ),
                backgroundColor: appBarBg,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      _isShowingPopup = false;
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildHeaderRow(context),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buildDataRow(context, service),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        fullscreenDialog: true,
      ),
    ).then((_) {
      if (mounted) {
        // Reset state completely when user closes the popup
        _isShowingPopup = false;
        _typedCode = '';
        widget.controller.clear();
        widget.focusNode.requestFocus();
        _keyboardFocusNode.requestFocus();
        
        // Cancel any pending timer
        _debounceTimer?.cancel();
        widget.onSearch(); 
      }
    });
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
                  ? const BorderSide(color: Colors.white12, width: 1)
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
  
  List<Widget> buildDataRow(BuildContext context, Service s) {
    String stripHtml(String text) {
      return text
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll(' ', ' ')
          .replaceAll('\r\n', '\n')
          .replaceAll(RegExp(r'\n{3,}'), '\n\n')
          .trim();
    }
    
    final values = [
      toNepaliNumber(s.code),
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
                  ? BorderSide(color: Colors.red.withOpacity(0.12), width: 1)
                  : BorderSide.none,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
      String nepaliCode = toNepaliNumber(code);
      
      final matched = widget.badapatradata
          .cast<Map<String, dynamic>>()
          .firstWhere(
            (s) {
              String serviceCode = s['code'].toString().trim();
              serviceCode = serviceCode.replaceAll('.', '').trim();
              String searchCode = nepaliCode.replaceAll('.', '').trim();
              String searchCodeEng = code.replaceAll('.', '').trim();
              
              return serviceCode == searchCode || serviceCode == searchCodeEng;
            },
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
    final isTV = Responsive.isTV(context);
    final height = isTV ? 40.0 : 30.0;
    
    return RawKeyboardListener(
      focusNode: _keyboardFocusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          _handleKeyPress(event as KeyEvent);
        }
      },
      child: Container(
        width: double.infinity,
        height: height,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isTV ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: isTV ? 4 : 3,
              offset: Offset(0, isTV ? 2 : 1.5),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          readOnly: isTV,
          showCursor: !isTV,
          enableInteractiveSelection: !isTV,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9*]')),
          ],
          onChanged: (value) {
            widget.onChanged?.call(value);
            
            // For mobile devices
            if (!isTV) {
              final code = value.trim();
              if (code.isNotEmpty && !_isShowingPopup) {
                widget.onCodeTyped?.call(code);
                final service = _fetchServiceByCode(code);
                // if (service != null && mounted) {
                //   _isShowingPopup = true;
                //   _showFullScreenTable(context, service);
                //  // widget.controller.clear();
                //   _isShowingPopup = false;
                // }
                if (service != null && mounted) {
                  _isShowingPopup = true;
                  _showFullScreenTable(context, service);
                }
              }
            }
          },
          onSubmitted: (_) => widget.onSearch(),
          style: TextStyle(fontSize: Responsive.fontSize(context, 12, 16)),
          decoration: InputDecoration(
            hintText: "(*) थिच्नुहोस् र नं. टाइप गर्नुहोस्",
            hintStyle: TextStyle(
              color: Colors.blue,
              fontSize: Responsive.fontSize(context, 10, 14),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTV ? 16 : 10,
              vertical: isTV ? 10 : 6,
            ),
            border: InputBorder.none,
            isDense: true,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                size: isTV ? 24 : 16,
                color: Colors.blue,
              ),
              onPressed: widget.onSearch,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ),
    );
  }
}




