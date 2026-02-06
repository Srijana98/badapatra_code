import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlBroadcastPage extends StatefulWidget {
  final String htmlContent;
  final int duration;
  final String orgId;

  const HtmlBroadcastPage({
    super.key,
    required this.htmlContent,
    required this.duration,
    required this.orgId,
  });

  @override
  State<HtmlBroadcastPage> createState() => _HtmlBroadcastPageState();
}

class _HtmlBroadcastPageState extends State<HtmlBroadcastPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    print("🎨 ========== HtmlBroadcastPage Initialized ==========");
    print("🎨 Duration: ${widget.duration}");
    print("🎨 OrgId: ${widget.orgId}");

    // Initialize WebView
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(widget.htmlContent);

    // Auto-close after duration
    Future.delayed(Duration(seconds: widget.duration), () {
      print("⏰ Duration expired, closing HtmlBroadcastPage");
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          
          // Close button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () {
                print("❌ Manual close button pressed");
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}