import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  String url;
  WebPage(this.url);


  @override
  State<WebPage> createState() => _WebPageState(url);
}

class _WebPageState extends State<WebPage> {
  String url;
  _WebPageState(this.url);
  var controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
        ..loadRequest(Uri.parse('$url'));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Page'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
