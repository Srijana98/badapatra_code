import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; 
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'models/service.dart';
import 'services/hive_service.dart';
import 'package:nagarikbadapatra/l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'main.dart';



class DisplayHeading {
  final String display;
  final String width;

  DisplayHeading({
    required this.display,
    required this.width,

 });

  factory DisplayHeading.fromJson(Map<String, dynamic> json) {
    return DisplayHeading(
      display: json['display']?.toString() ?? 'N',
      width: json['width']?.toString() ?? '10',
    );
  }

  bool get isVisible => display.toUpperCase() == 'Y';
}

class BadapatraDisplayHeading {
  final DisplayHeading sn;
  final DisplayHeading serviceTypename;
  final DisplayHeading serviceRecdetail;
  final DisplayHeading fee;
  final DisplayHeading time;
  final DisplayHeading serviceProvider;
  final DisplayHeading complainListen;

  BadapatraDisplayHeading({
    required this.sn,
    required this.serviceTypename,
    required this.serviceRecdetail,
    required this.fee,
    required this.time,
    required this.serviceProvider,
    required this.complainListen,
  });

  factory BadapatraDisplayHeading.fromJson(Map<String, dynamic> json) {
    return BadapatraDisplayHeading(
      sn: DisplayHeading.fromJson(json['sn'] ?? {}),
      serviceTypename: DisplayHeading.fromJson(json['service_typename'] ?? {}),
      serviceRecdetail: DisplayHeading.fromJson(json['service_recdetail'] ?? {}),
      fee: DisplayHeading.fromJson(json['fee'] ?? {}),
      time: DisplayHeading.fromJson(json['time'] ?? {}),
      serviceProvider: DisplayHeading.fromJson(json['service_provider'] ?? {}),
      complainListen: DisplayHeading.fromJson(json['complain_listen'] ?? {}),
    );
  }

  List<ColumnConfig> getVisibleColumns(double availableWidth, BuildContext context) {
    double totalParts = 0;
    if (sn.isVisible) totalParts += double.parse(sn.width);
    if (serviceTypename.isVisible) totalParts += double.parse(serviceTypename.width);
    if (serviceRecdetail.isVisible) totalParts += double.parse(serviceRecdetail.width);
    if (fee.isVisible) totalParts += double.parse(fee.width);
    if (time.isVisible) totalParts += double.parse(time.width);
    if (serviceProvider.isVisible) totalParts += double.parse(serviceProvider.width);
    if (complainListen.isVisible) totalParts += double.parse(complainListen.width);

    final double pixelPerPart = totalParts > 0 ? availableWidth / totalParts : 10;

    List<ColumnConfig> columns = [];

    if (sn.isVisible) columns.add(ColumnConfig(key: 'sn', width: double.parse(sn.width) * pixelPerPart, title: AppLocalizations.of(context)!.idNo));
    if (serviceTypename.isVisible) columns.add(ColumnConfig(key: 'service_typename', width: double.parse(serviceTypename.width) * pixelPerPart, title: AppLocalizations.of(context)!.serviceType));
    if (serviceRecdetail.isVisible) columns.add(ColumnConfig(key: 'service_recdetail', width: double.parse(serviceRecdetail.width) * pixelPerPart, title: AppLocalizations.of(context)!.serviceRequirement));
    if (fee.isVisible) columns.add(ColumnConfig(key: 'fee', width: double.parse(fee.width) * pixelPerPart, title: AppLocalizations.of(context)!.price));
    if (time.isVisible) columns.add(ColumnConfig(key: 'time', width: double.parse(time.width) * pixelPerPart, title: AppLocalizations.of(context)!.time));
    if (serviceProvider.isVisible) columns.add(ColumnConfig(key: 'service_provider', width: double.parse(serviceProvider.width) * pixelPerPart, title: AppLocalizations.of(context)!.serviceBranch));
    if (complainListen.isVisible) columns.add(ColumnConfig(key: 'complain_listen', width: double.parse(complainListen.width) * pixelPerPart, title: AppLocalizations.of(context)!.commentSection));

    return columns;
  }
}

class ColumnConfig {
  final String key;
  final double width;
  final String title;
  
  
  ColumnConfig({required this.key, required this.width, required this.title});
}

String toNepaliNumber(String input) {
  const englishDigits = ['0','1','2','3','4','5','6','7','8','9'];
  const nepaliDigits = ['०','१','२','३','४','५','६','७','८','९'];

  String output = input;
  for (int i = 0; i < englishDigits.length; i++) {
    output = output.replaceAll(englishDigits[i], nepaliDigits[i]);
  }
  return output;
}

class WaraBadapatraTable extends StatefulWidget {
  final String searchCode;
  final Function(Service)? onCodeTap;
  final String userid;
  final String orgid;
  final String orgCode;
  final BadapatraDisplayHeading? displayHeading;
  final List<dynamic> teams;

  const WaraBadapatraTable({
    Key? key,
    this.searchCode = "",
    this.onCodeTap,
    required this.userid,
    required this.orgid,
    required this.orgCode,
    this.displayHeading,
    this.teams = const [],
  }) : super(key: key);

  @override
  State<WaraBadapatraTable> createState() => _WaraBadapatraTableState();
}

class _WaraBadapatraTableState extends State<WaraBadapatraTable> {
  late Future<List<Service>> futureServices;
  final ScrollController _headerController = ScrollController();
  final ScrollController _bodyController = ScrollController();
  final ScrollController _vController = ScrollController();
 
  bool _isAutoScrolling = false;
  final double _scrollPixelsPerSecond = 15.0; // Slightly increased for smoother visual flow
  bool _isSyncingScroll = false;
  bool _hasInitialized = false;
  double _savedScrollPosition = 0.0; 

  static final RegExp _htmlRegex = RegExp(r'<[^>]*>');
  static final RegExp _newlineRegex = RegExp(r'\n{3,}');

   final Map<String, String> _cleanedTextCache = {};
 
  @override
  void initState() {
    super.initState();
    futureServices = _fetchWaraBadapatra();
    _hasInitialized = false;
    _headerController.addListener(_onHeaderScroll);
    _bodyController.addListener(_onBodyScroll);
  }

  @override
  void didUpdateWidget(WaraBadapatraTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchCode.isEmpty && widget.searchCode.isNotEmpty) {
      if (_vController.hasClients) {
        _savedScrollPosition = _vController.offset;
      }
    }
  }

  @override
  void dispose() {
    _isAutoScrolling = false; // Stop the loop
    _headerController.removeListener(_onHeaderScroll);
    _bodyController.removeListener(_onBodyScroll);
    _headerController.dispose();
    _bodyController.dispose();
    _vController.dispose();
    super.dispose();
  }

  void _onHeaderScroll() {
    if (_isSyncingScroll) return;
    _isSyncingScroll = true;
    if (_bodyController.hasClients) {
      _bodyController.jumpTo(_headerController.offset);
    }
    _isSyncingScroll = false;
  }

  void _onBodyScroll() {
    if (_isSyncingScroll) return;
    _isSyncingScroll = true;
    if (_headerController.hasClients) {
      _headerController.jumpTo(_bodyController.offset);
    }
    _isSyncingScroll = false;
  }

  Future<List<Service>> _fetchWaraBadapatra() async {
    final url = Uri.parse(
      kIsWeb
          ? 'https://cors-anywhere.herokuapp.com/https://digitalbadapatra.com/api/v1/get_ward_badapatra'
          : 'https://digitalbadapatra.com/api/v1/get_ward_badapatra',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'userid': widget.userid,
          'orgid': widget.orgid,
          'org_code': widget.orgCode,
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final list = decoded['data'] ?? [];
        final services = (list as List).map((e) => Service.fromJson(e)).toList();
        await HiveService.saveServices(services);
        return services;
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
    return await HiveService.getServices();
  }

  // --- NEW: NATIVE SILKY SMOOTH AUTO SCROLL ---
  void _stopAutoScroll() {
    _isAutoScrolling = false;
    // Calling jumpTo on the current position cancels any running animateTo
    if (_vController.hasClients) {
      _vController.jumpTo(_vController.offset);
    }
  }

  Future<void> _startAutoScrollFromPosition(double fromPosition) async {
    _stopAutoScroll();
    _isAutoScrolling = true;

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted || !_vController.hasClients || !_isAutoScrolling) return;

    final maxScroll = _vController.position.maxScrollExtent;
    final safePosition = fromPosition > maxScroll ? maxScroll : fromPosition;
    
    if (safePosition > 0) _vController.jumpTo(safePosition);

    _runNativeScrollLoop();
  }

  Future<void> _startAutoScroll() async {
    _stopAutoScroll();
    _isAutoScrolling = true;

    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted || !_vController.hasClients || !_isAutoScrolling) return;

    if (_vController.hasClients) _vController.jumpTo(0);

    _runNativeScrollLoop();
  }

  Future<void> _runNativeScrollLoop() async {
    if (!mounted || !_vController.hasClients || !_isAutoScrolling) return;

    final double currentScroll = _vController.offset;
    final double maxScroll = _vController.position.maxScrollExtent;

    if (maxScroll <= 0) {
      // List is too short to scroll, check again in 1 second
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) _runNativeScrollLoop();
      return;
    }

    final double remainingDistance = maxScroll - currentScroll;
    
    // Calculate exactly how long it should take to reach the bottom at our desired speed
    final int durationMs = ((remainingDistance / _scrollPixelsPerSecond) * 1000).toInt();

    if (remainingDistance > 0) {
      // Let Flutter's native engine handle the animation (Super Smooth)
      await _vController.animateTo(
        maxScroll,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.linear, // Constant speed
      );
    }

    // Once it reaches the bottom, pause, reset to top, and loop
    if (_isAutoScrolling && mounted) {
      await Future.delayed(const Duration(seconds: 2)); // Pause at bottom
      if (mounted && _vController.hasClients) {
        _vController.jumpTo(0); // Instantly jump to top
        _runNativeScrollLoop(); // Start again
      }
    }
  }
 

  String _getFieldValue(Service service, String fieldKey) {
    switch (fieldKey) {
      case 'sn': return toNepaliNumber(service.code);
      case 'service_typename': return service.serviceTypeName;
      case 'service_recdetail': return service.serviceRecDetail;
      case 'fee': return service.fee;
      case 'time': return service.time;
      case 'service_provider': return service.serviceProvider;
      case 'complain_listen': return service.complainListen;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        if (availableWidth.isInfinite) availableWidth = MediaQuery.of(context).size.width;

        final visibleColumns = widget.displayHeading?.getVisibleColumns(availableWidth, context) ?? [];
        final double totalTableWidth = visibleColumns.fold(0, (sum, col) => sum + col.width);

        if (visibleColumns.isEmpty) {
          return const Center(child: Text('Display configuration not available', style: TextStyle(fontSize: 18, color: Colors.red)));
        }

        return FutureBuilder<List<Service>>(
          future: futureServices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('डेटा उपलब्ध छैन।', style: TextStyle(fontSize: 28)));

            final filtered = widget.searchCode.isEmpty
                ? snapshot.data!
                : snapshot.data!.where((s) {
                    String serviceCode = s.code.replaceAll('.', '').trim();
                    String nepaliSearch = toNepaliNumber(widget.searchCode).replaceAll('.', '').trim();
                    String engSearch = widget.searchCode.replaceAll('.', '').trim();
                    return serviceCode == nepaliSearch || serviceCode == engSearch;
                  }).toList();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (!_hasInitialized) {
                _stopAutoScroll();
                if (_headerController.hasClients) _headerController.jumpTo(0);
                if (_bodyController.hasClients) _bodyController.jumpTo(0);
                if (_vController.hasClients) _vController.jumpTo(0);

                _hasInitialized = true;
                if (filtered.length > 2) _startAutoScroll();
              } else {
                if (widget.searchCode.isNotEmpty) {
                  _stopAutoScroll();
                } else if (widget.searchCode.isEmpty && !_isAutoScrolling) {
                  if (filtered.length > 2) _startAutoScrollFromPosition(_savedScrollPosition);
                }
              }
            });

            return Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        height: isPortrait ? 65 : 55, 
                        color: const Color(0xFFC40000),
                        child: SingleChildScrollView(
                          controller: _headerController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: Row(
                            children: List.generate(visibleColumns.length, (i) {
                              final column = visibleColumns[i];
                              final isLast = i == visibleColumns.length - 1;
                              return Container(
                                width: column.width,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), 
                                decoration: BoxDecoration(
                                  color: i.isEven ? const Color(0xFFE45C53) : const Color(0xFFC40000),
                                  border: Border(right: isLast ? BorderSide.none : BorderSide(color: Colors.grey[350]!, width: 1)),
                                ),
                                child: Text(
                                  column.title,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isPortrait ? 12 : 11, height: 1.3),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),

                      // Body
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _bodyController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: SizedBox(
                            width: totalTableWidth,
                            child: ListView.builder(
                              padding: EdgeInsets.zero, 
                              controller: _vController,
                              physics: const ClampingScrollPhysics(),
                             // cacheExtent: 250, 
                               cacheExtent: 500, 
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final service = filtered[index];
                                final isEven = index % 2 == 0;
                                final bg = isEven ? const Color(0xFFF9D7D7) : const Color(0xFF006699);
                                final textColor = isEven ? const Color(0xFF2056AE) : Colors.white;

                                return Material(
                                  color: bg,
                                  child: InkWell(
                                    onTap: () => widget.onCodeTap?.call(service),
                                    child: Table(
                                      columnWidths: {
                                        for (int i = 0; i < visibleColumns.length; i++)
                                          i: FixedColumnWidth(visibleColumns[i].width),
                                      },
                                      border: TableBorder(
                                        bottom: BorderSide(color: Colors.grey[350]!, width: 1),
                                        verticalInside: const BorderSide(color: Color(0xFFDFC2C4), width: 1),
                                      ),
                                      children: [
                                        TableRow(
                                          children: visibleColumns.map((column) {
                                            final value = _getFieldValue(service, column.key);
                                            return _cellWithBorder(
                                              value,
                                              textColor,
                                              bold: column.key == 'sn',
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Widget _cellWithBorder(String text, Color color, {bool bold = false}) {
  //   final String cleanText = text
  //       .replaceAll(_htmlRegex, '')
  //       .replaceAll('&nbsp;', ' ')
  //       .replaceAll('\r\n', '\n')
  //       .replaceAll(_newlineRegex, '\n\n')
  //       .trim();

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  //     child: Text(
  //       cleanText,
  //       style: TextStyle(
  //         color: color, 
  //         fontSize: 13.8, 
  //         height: 1.5, 
  //         fontWeight: bold ? FontWeight.bold : FontWeight.w600
  //       ),
  //       softWrap: true,
  //       overflow: TextOverflow.visible,
  //     ),
  //   );
  // }

  Widget _cellWithBorder(String text, Color color, {bool bold = false}) {
    String cleanText;
    if (_cleanedTextCache.containsKey(text)) {
      cleanText = _cleanedTextCache[text]!;
    } else {
      // यदि छैन भने मात्र Regex चलाउने र Cache मा सेभ गर्ने
      cleanText = text
          .replaceAll(_htmlRegex, '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('\r\n', '\n')
          .replaceAll(_newlineRegex, '\n\n')
          .trim();
      _cleanedTextCache[text] = cleanText;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        cleanText,
        style: TextStyle(
          color: color, 
          fontSize: 13.8, 
          height: 1.5, 
          fontWeight: bold ? FontWeight.bold : FontWeight.w600
        ),
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
    );
  }
}


