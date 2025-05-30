import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Design contraints/app color.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String email;
  final String password;

  const WebViewPage({
    Key? key,
    required this.url,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}
class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _hasInjected = false;
  String _currentUrl = '';

  static const String ownerPageUrl = 'https://backend.jobizoindia.com/owner';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("🔄 Loading $url");
          },
          onPageFinished: (url) async {
            debugPrint("✅ Finished $url");
            _currentUrl = url;

            if (!_hasInjected && url.contains('login')) {
              _hasInjected = true;
              await _injectLoginData();
            }
          },
          onWebResourceError: (error) =>
              debugPrint("❌ Error: ${error.description}"),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _injectLoginData() async {
    final script = """
      (function() {
        document.querySelector('input[name="email"]').value = "${widget.email}";
        document.querySelector('input[name="password"]').value = "${widget.password}";
        document.querySelector('#loginForm button[type="submit"]').click();
      })();
    """;

    await _controller.runJavaScript(script);
    debugPrint("🚀 Injected email + password and submitted form.");
  }

  Future<bool> _handleBack() async {
    if (_currentUrl == ownerPageUrl) {
      debugPrint("🚪 On owner page → exiting app.");
      SystemNavigator.pop();
      return false;
    }

    if (await _controller.canGoBack()) {
      debugPrint("↩️ Can go back → navigating back in WebView.");
      _controller.goBack();
      return false;
    }

    debugPrint("🚪 No history → exiting app.");
    SystemNavigator.pop();
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        body: Container(
          color: AppColors.gold,
          child: SafeArea(
            child: WebViewWidget(controller: _controller),
          ),
        ),
      ),
    );
  }
}
