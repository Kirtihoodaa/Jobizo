import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => debugPrint("🔄 Loading $url"),
          onPageFinished: (url) async {
            debugPrint("✅ Finished $url");
            if (!_hasInjected && url.contains('login')) {
              _hasInjected = true; // Prevent re-injection after logout
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:AppColors.gold, // 👈 Set your desired background color here
        child: SafeArea(
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
