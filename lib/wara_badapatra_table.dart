
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'models/service.dart';
import 'services/hive_service.dart';
import 'package:nagarikbadapatra/l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';


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

  // Get list of visible columns with their data using localization
  List<ColumnConfig> getVisibleColumns(bool isPortrait, BuildContext context) {
    final baseMultiplier = isPortrait ? 16.0 : 14.5;
    List<ColumnConfig> columns = [];

    if (sn.isVisible) {
      columns.add(ColumnConfig(
        key: 'sn',
        width: double.parse(sn.width) * baseMultiplier,
        title: AppLocalizations.of(context)!.idNo,
      ));
    }
    if (serviceTypename.isVisible) {
      columns.add(ColumnConfig(
        key: 'service_typename',
        width: double.parse(serviceTypename.width) * baseMultiplier,
        title: AppLocalizations.of(context)!.serviceType,
      ));
    }
    if (serviceRecdetail.isVisible) {
      columns.add(ColumnConfig(
        key: 'service_recdetail',
        width: double.parse(serviceRecdetail.width) * baseMultiplier,
        title: AppLocalizations.of(context)!.serviceRequirement,
      ));
    }
    if (fee.isVisible) {
      columns.add(ColumnConfig(
        key: 'fee',
        width: double.parse(fee.width) * baseMultiplier,
        title: AppLocalizations.of(context)!.price,
      ));
    }
    if (time.isVisible) {
      columns.add(ColumnConfig(
        key: 'time',
        width: double.parse(time.width) * baseMultiplier,
        title: AppLocalizations.of(context)!.time,
      ));
    }
    if (serviceProvider.isVisible) {
      columns.add(ColumnConfig(
        key: 'service_provider',
        width: double.parse(serviceProvider.width) * baseMultiplier,
        title: AppLocalizations.of(context)!.serviceBranch,
      ));
    }
    if (complainListen.isVisible) {
      columns.add(ColumnConfig(
        key: 'complain_listen',
        width: double.parse(complainListen.width) * baseMultiplier,
        title: AppLocalizations.of(context)!.commentSection,
      ));
    }

    return columns;
  }


}  

class ColumnConfig {
  final String key;
  final double width;
  final String title;

  ColumnConfig({
    required this.key,
    required this.width,
    required this.title,
  });
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
  Timer? _autoScrollTimer;

  bool _isSyncingScroll = false;

  @override
  void initState() {
    super.initState();
    futureServices = _fetchWaraBadapatra();

    _headerController.addListener(_onHeaderScroll);
    _bodyController.addListener(_onBodyScroll);
  }

  @override
  void dispose() {
    _headerController.removeListener(_onHeaderScroll);
    _bodyController.removeListener(_onBodyScroll);
    _headerController.dispose();
    _bodyController.dispose();
    _vController.dispose();
    _autoScrollTimer?.cancel();
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
       print("🔹 HTTP status: ${response.statusCode}");
    print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final list = decoded['data'] ?? [];
        final services =
            (list as List).map((e) => Service.fromJson(e)).toList();
        await HiveService.saveServices(services);
        return services;
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
    return await HiveService.getServices();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    const speed = 0.9;
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_vController.hasClients) return;
      final pos = _vController.position;
      if (pos.pixels >= pos.maxScrollExtent - 1) {
        _vController.jumpTo(0);
      } else {
        _vController.animateTo(
          pos.pixels + speed,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
    });
  }

  // Helper method to get field value based on key
  String _getFieldValue(Service service, String fieldKey) {
    switch (fieldKey) {
      case 'sn':
        return service.code;
      case 'service_typename':
        return service.serviceTypeName;
      case 'service_recdetail':
        return service.serviceRecDetail;
      case 'fee':
        return service.fee;
      case 'time':
        return service.time;
      case 'service_provider':
        return service.serviceProvider;
      case 'complain_listen':
        return service.complainListen;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Get visible columns from display heading
    final visibleColumns = widget.displayHeading?.getVisibleColumns(isPortrait, context) ?? [];
    final double totalTableWidth =
    visibleColumns.fold(0, (sum, col) => sum + col.width);

    // If no display heading provided, show error
    if (visibleColumns.isEmpty) {
      return const Center(
        child: Text(
          'Display configuration not available',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return FutureBuilder<List<Service>>(
      future: futureServices,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('डेटा उपलब्ध छैन।', style: TextStyle(fontSize: 28)),
          );
        }

        final filtered =
            widget.searchCode.isEmpty
                ? snapshot.data!
                : snapshot.data!
                    .where((s) => s.code.trim() == widget.searchCode.trim())
                    .toList();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Reset horizontal scroll to start position (left side)
          if (_headerController.hasClients) {
            _headerController.jumpTo(0);
          }
          if (_bodyController.hasClients) {
            _bodyController.jumpTo(0);
          }
          
          // Start vertical auto-scroll
          if (_autoScrollTimer == null && filtered.length > 2) {
            _startAutoScroll();
          }
        });

        return Column(
          children: [
            // TABLE SECTION
            Expanded(
              child: Column(
                children: [
                  // RED HEADER
                  Container(
                    height: isPortrait ? 58 : 52,
                    color: const Color(0xFFC40000),
                    child: SingleChildScrollView(
                      controller: _headerController,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: Row(
                        children: List.generate(visibleColumns.length, (i) {
                          final column = visibleColumns[i];
                          return Container(
                            width: column.width,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            color:
                                i.isEven
                                    ? const Color(0xFFE45C53)
                                    : const Color(0xFFC40000),
                            child: Text(
                              column.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // BODY
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _vController,
                      child: SingleChildScrollView(
                        controller: _bodyController,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children:
                              filtered.asMap().entries.map((e) {
                                final service = e.value;
                                final index = e.key;
                                final isEven = index % 2 == 0;
                                final bg =
                                    isEven
                                        ? const Color(0xFFF9D7D7)
                                        : const Color(0xFF006699);
                                final textColor =
                                    isEven ? const Color(0xFF006699) : Colors.white;

                                return InkWell(
                                  onTap: () => widget.onCodeTap?.call(service),
                                  child: Container(
                                    color: bg,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      children: visibleColumns.map((column) {
                                        final value = _getFieldValue(service, column.key);
                                        final isBold = column.key == 'sn';
                                        
                                        return _cell(
                                          column.width,
                                          value,
                                          textColor,
                                          bold: isBold,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TEAM CARDS SECTION
            // if (widget.teams.isNotEmpty)
            //   Container(
            //     height: isPortrait ? 200 : 180,
            //     color: Colors.white,
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //       itemCount: widget.teams.length,
            //       itemBuilder: (context, index) {
            //         final team = widget.teams[index];
            //         return Padding(
            //           padding: const EdgeInsets.only(right: 16),
            //           child: _buildTeamCard(team),
            //         );
            //       },
            //     ),
            //   ),
          ],
        );
      },
    );
  }

  // Build individual team card
  Widget _buildTeamCard(Map<String, dynamic> team) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const Text(
            'गुनासो सुन्ने अधिकारी',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Profile Image
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              radius: 28,
              backgroundImage: team['photo'] != null && team['photo'].toString().isNotEmpty
                  ? NetworkImage(team['photo'])
                  : const AssetImage('assets/images/profile.jpeg') as ImageProvider,
            ),
          ),

          const SizedBox(height: 6),

          // Name pill
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              team['name'] ?? 'N/A',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Designation
          if (team['designation'] != null)
            Text(
              team['designation'],
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 4),

          // Phone
          if (team['phone'] != null)
            Text(
              'फोन नं.: ${team['phone']}',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  
// AFTER:
// Widget _cell(double width, String text, Color color, {bool bold = false}) {
//   final bool isHtml = text.contains('<') && text.contains('>');

//   return SizedBox(
//     width: width,
//     child: isHtml
//         ? Html(
//             data: text,
//             style: {
//               "body": Style(
//                 color: color,
//                 fontSize: FontSize(13.0),
//                 margin: Margins.zero,
//                 padding: HtmlPaddings.zero,
//               ),
//               "ul": Style(
//                 // ✅ Left padding diyera bullet visible huncha
//                 margin: Margins.only(left: 0),
//                 padding: HtmlPaddings.only(left: 16),
//               ),
//               "li": Style(
//                 color: color,
//                 fontSize: FontSize(13.0),
//                 lineHeight: LineHeight(1.4),
//                 // ✅ Bullet visible garnu ko lagi
//                // listStyleType: ListStyleType.disc,
//                  listStyleType: ListStyleType.none,
//               ),
//               "p": Style(
//                 margin: Margins.zero,
//                 padding: HtmlPaddings.zero,
//               ),
//             },
//           )
//         : Text(
//             text,
//             style: TextStyle(
//               color: color,
//               fontSize: 13.8,
//               height: 1.5,
//               fontWeight: bold ? FontWeight.bold : FontWeight.normal,
//             ),
//             softWrap: true,
//             overflow: TextOverflow.visible,
//           ),
//   );
// }
// REPLACE WITH:
Widget _cell(double width, String text, Color color, {bool bold = false}) {
  // HTML tags strip garera clean text matra nikaal
  final String cleanText = text
      .replaceAll(RegExp(r'<[^>]*>'), '') 
      .replaceAll('&nbsp;', ' ')          
      .replaceAll('\r\n', '\n')            
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();

  return SizedBox(
    width: width,
    child: Text(
      cleanText,
      style: TextStyle(
        color: color,
        fontSize: 13.8,
        height: 1.5,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
      softWrap: true,
      overflow: TextOverflow.visible,
    ),
  );
}
}


