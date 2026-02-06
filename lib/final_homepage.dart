
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'components/bottom_news_bar.dart';
import 'components/header_section.dart';
import 'components/sidebar_widget.dart';
import 'components/top_news_bar.dart';
import 'components/search_bar.dart' hide BottomNewsBar;

import 'wara_badapatra_table.dart';
import 'team_page.dart';
import 'models/service.dart';

import 'services/pusher_service.dart';
import 'brodcast_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'youtube_page.dart';
import 'html_broadcast_page.dart';


class FinalHomePage extends StatefulWidget {
  final String userid;
  final String orgid;
  final String orgCode;
  final List<dynamic> teams;
  final Map<String, dynamic> loginData;
  final String? token;
  final List<dynamic> badapatradata;
  //final Map<String, dynamic> displayHeading;
  final Map<String, dynamic>? displayHeading;
   final List<dynamic> gallery; 


  const FinalHomePage({
    Key? key,
    required this.userid,
    required this.orgid,
    required this.orgCode,
    required this.teams,
    required this.loginData,
    this.token,
    required this.badapatradata,
    //required this.displayHeading,
    this.displayHeading,
     required this.gallery,
  

  }) : super(key: key);

  @override
  State<FinalHomePage> createState() => _FinalHomePageState();
}

class _FinalHomePageState extends State<FinalHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String _searchCode = "";
  Service? _selectedService;

  Map<String, dynamic> orgInfo = {};
  List<dynamic> rssItems = [];
  List<dynamic> _teams = [];
  List<dynamic> _badapatradata = [];
  List<dynamic> _notices = [];
  bool isLoadingOrgInfo = true;
  BadapatraDisplayHeading? displayHeading;
   List<dynamic> _galleryItems = [];

  bool _isBroadcastOpen = false;


@override
void initState() {
  super.initState();

  orgInfo = widget.loginData['organization_info'] ?? {};
  rssItems = widget.loginData['rss_items'] ?? [];
  _teams = List<Map<String, dynamic>>.from(
    widget.teams.map((team) => team as Map<String, dynamic>)
  );
  _badapatradata = List.from(widget.badapatradata); 
  _notices = widget.loginData['notices'] ?? [];
  _galleryItems = List.from(widget.gallery);  
  
  // Display heading configuration
  print("🔍 Loading display heading configuration...");
  if (widget.displayHeading != null && widget.displayHeading!.isNotEmpty) {
    try {
      displayHeading = BadapatraDisplayHeading.fromJson(widget.displayHeading!);
      print("✅ Display heading loaded successfully!");
      print("   - SN visible: ${displayHeading!.sn.isVisible}, width: ${displayHeading!.sn.width}");
      print("   - Service Type visible: ${displayHeading!.serviceTypename.isVisible}, width: ${displayHeading!.serviceTypename.width}");
    } catch (e) {
      print("❌ Error parsing display heading: $e");
      print("⚠️ Using default configuration");
      displayHeading = _getDefaultDisplayHeading();
    }
  } else {
    print("⚠️ No display heading provided, using default configuration");
    displayHeading = _getDefaultDisplayHeading();
  }

  fetchOrganizationInfo();

  // ✅ UPDATED: Initialize Pusher with orgId from user_info
  final pusherArray = widget.loginData['pusher_array'];
  if (pusherArray != null) {
    final apiKey = pusherArray['pusher_app_key'];
    final cluster = pusherArray['cluster'];
    
    if (apiKey != null && cluster != null) {
      print("🔍 Initializing Pusher for orgId: ${widget.orgid}");
      PusherService.init(
        apiKey: apiKey,
        cluster: cluster,
        orgId: widget.orgid, 
       onEmergencyBroadcast: _handleBroadcastEvent,
        onRestartSignage: (_) => _restartApp(),
      );
    } else {
      print("⚠️ Pusher credentials missing");
    }
  } else {
    print("⚠️ No pusher_array found in login data");
  }
}



BadapatraDisplayHeading _getDefaultDisplayHeading() {
    return BadapatraDisplayHeading.fromJson({
      "sn": {"display": "Y", "width": "5"},
      "service_typename": {"display": "Y", "width": "15"},
      "service_recdetail": {"display": "Y", "width": "30"},
      "fee": {"display": "Y", "width": "10"},
      "time": {"display": "Y", "width": "10"},
      "service_provider": {"display": "Y", "width": "15"},
      "complain_listen": {"display": "Y", "width": "15"},
    });
  }

  Future<void> fetchOrganizationInfo() async {
    try {
      final response = await http.post(
        Uri.parse('https://digitalbadapatra.com/api/v1/get_org_info'),
        body: {
          'userid': widget.userid,
          'orgid': widget.orgid,
          'org_code': widget.orgCode,

        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true || data['status'] == "success") {
          setState(() {
            rssItems = data['rss_items'] ?? rssItems;
            isLoadingOrgInfo = false;
          });

          if (data['active_broadcast'] != null) {
            _handleBroadcastEvent(data['active_broadcast']);
          }
        }
      }
    } catch (e) {
      print("❌ Error fetching org info: $e");
    } finally {
      setState(() => isLoadingOrgInfo = false);
    }
  }

  Future<void> _fetchNewData() async {
    setState(() => isLoadingOrgInfo = true);
    try {
      final response = await http.post(
        Uri.parse('https://digitalbadapatra.com/api/v1/get_fetch_data_record'),
        body: {'userid': widget.userid, 'orgid': widget.orgid},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            orgInfo = data['organization_info'] ?? orgInfo;
            rssItems = data['rss_items'] ?? rssItems;
            _teams = data['teams'] ?? _teams;
          });

          if (data['active_broadcast'] != null) {
            _handleBroadcastEvent(data['active_broadcast']);
          }
        }
      }
    } catch (e) {
      print("❌ Error fetching new data: $e");
    } finally {
      setState(() => isLoadingOrgInfo = false);
    }
  }


void _handleBroadcastEvent(dynamic data) {
  print("🎯 ========== BROADCAST EVENT RECEIVED ==========");
  print("🎯 Raw data type: ${data.runtimeType}");
  print("🎯 Raw data: $data");
  
  if (_isBroadcastOpen || !mounted) {
    print("❌ Blocked: _isBroadcastOpen=$_isBroadcastOpen, mounted=$mounted");
    return;
  }
  
  _isBroadcastOpen = true;
  print("✅ Proceeding with broadcast...");

  try {
    Map<String, dynamic> parsed;
    
    if (data is String) {
      print("📝 Data is String, parsing...");
      if (data.startsWith('{')) {
        parsed = Map<String, dynamic>.from(jsonDecode(data));
        print("✅ Parsed JSON");
      } else {
        parsed = {"url": data, "type": "video", "duration": 60};
        print("✅ Created default structure");
      }
    } else {
      print("📝 Data is Map, converting...");
      parsed = Map<String, dynamic>.from(data);
      print("✅ Converted Map");
    }

  
    if (parsed.containsKey('template')) {
      print("🎨 HTML template detected, rendering WebView...");

      int durationMinutes = parsed['duration'] is int
          ? parsed['duration']
          : int.tryParse(parsed['duration'].toString()) ?? 2;
      
      final int duration = durationMinutes * 60;
      
      print("🎨 Parsed duration: $durationMinutes minutes = $duration seconds");
      
      Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => HtmlBroadcastPage(
            duration: duration,
            orgId: widget.orgid,
            htmlContent: parsed['template'],
          ),
        ),
      ).then((_) {
        print("✅ HtmlBroadcastPage closed");
        _isBroadcastOpen = false;
      });
      return;
    }

 
    final String type = parsed['type'] ?? 'video';
    final String url = parsed['url'] ?? '';
    final int duration = parsed['duration'] is int
        ? parsed['duration']
        : int.tryParse(parsed['duration'].toString()) ?? 60;

    print("🎬 Extracted values:");
    print("   - Type: $type");
    print("   - URL: $url");
    print("   - Duration: $duration");
    print("   - OrgId: ${widget.orgid}");

    if (url.isEmpty) {
      print("❌ URL is empty, aborting");
      _isBroadcastOpen = false;
      return;
    }

    print("🚀 Navigating to BroadcastPage...");
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BroadcastPage(
          type: type,
          url: url,
          duration: duration,
          orgId: widget.orgid,
        ),
      ),
    ).then((_) {
      print("✅ BroadcastPage closed");
      _isBroadcastOpen = false;
    });
  } catch (e) {
    print("❌ ========== ERROR IN BROADCAST EVENT ==========");
    print("❌ Error: $e");
    print("❌ Stack trace: ${StackTrace.current}");
    _isBroadcastOpen = false;
  }
}

  void _restartApp() {
    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
    _fetchNewData();
    print("🔄 App restarted via Pusher");
  }

  void _performSearch() =>
      setState(() => _searchCode = _searchController.text.trim());

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _keyboardFocusNode.dispose();
    _scrollController.dispose();
    PusherService.disconnect(); // Static call
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingOrgInfo) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RawKeyboardListener(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        onKey: (event) {
          if (event.logicalKey.keyLabel == '*') _selectedService = null;
        },
        child: Column(
          children: [
            HeaderSection(orgInfo: orgInfo),
             TopNewsBar(notices: _notices),
            const SizedBox(height: 8),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
 



  bottomNavigationBar: BottomNewsBar(
  newsItems: rssItems,
  rssType: widget.loginData['rss_type'] ?? 'News',
  qrUrl: widget.loginData['qr_url'],
),
    );
  }

  

Widget _buildMainContent() {
  final orientation = MediaQuery.of(context).orientation;
  final screenHeight = MediaQuery.of(context).size.height;

  if (orientation == Orientation.landscape) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 85,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomSearchBar(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onSearch: _performSearch,
                         badapatradata: _badapatradata,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              width: constraints.maxWidth,
                              height: screenHeight * 0.7,
                              child: WaraBadapatraTable(
                                key: ValueKey(_searchCode),
                                searchCode: _searchCode,
                                onCodeTap:
                                    (service) => setState(
                                      () => _selectedService = service,
                                    ),
                                userid: widget.userid,
                                orgid: widget.orgid,
                                orgCode: widget.orgCode,
                                displayHeading: displayHeading,
                      
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

             


              if (_teams.isNotEmpty)
  SizedBox(
    width: 380,
    child: Column(
      children: [
        // Team Carousel
        Container(
          height: screenHeight * 0.45,
          margin: const EdgeInsets.only(right: 12, top: 1),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TeamCarousel(
            teams: _teams,
            orgInfo: orgInfo,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Gallery Carousel below Team Carousel
        if (_galleryItems.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: GalleryCarousel(
              galleryItems: _galleryItems,
            ),
          ),
      ],
    ),
  ),
                 
            ],
          ),             
                          const SizedBox(height: 20),
        ],
      ),
    );
  }
  

  return SingleChildScrollView(
    controller: _scrollController,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomSearchBar(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onSearch: _performSearch,
             badapatradata: _badapatradata,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: screenHeight * 0.5,
              child: WaraBadapatraTable(
                key: ValueKey(_searchCode),
                searchCode: _searchCode,
                onCodeTap:
                    (service) => setState(() => _selectedService = service),
                userid: widget.userid,
                orgid: widget.orgid,
                orgCode: widget.orgCode,
                 displayHeading: displayHeading,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
       

        if (_teams.isNotEmpty)
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        // Team Carousel
        SizedBox(
          height: screenHeight * 0.3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TeamCarousel(
              teams: _teams,
              orgInfo: orgInfo,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Gallery Carousel below Team Carousel
        if (_galleryItems.isNotEmpty)
          GalleryCarousel(
            galleryItems: _galleryItems,
          ),
      ],
    ),
  ),
    
      ],
    ),
  );

}
  
}