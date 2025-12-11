import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class ReadablePage extends StatefulWidget {
  const ReadablePage({super.key});

  @override
  State<ReadablePage> createState() => _ReadablePageState();
}

class _ReadablePageState extends State<ReadablePage> {
  WebViewController? _controller;
  String _status = '載入中...';
  late final bool _webviewSupported;
  static const _fallbackHtml = '''
<html>
<body style="background:#111;color:#eee;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;padding:16px;">
<h3>官方文件節錄</h3>
<p>Using this package eliminates the need to match strings between host and client for the names and data types of messages. It supports nested classes, grouping messages into APIs, generation of asynchronous wrapper code, and sending messages in either direction. The generated code is readable and guarantees there are no conflicts between multiple clients of different versions.</p>
<p>原文：<a href="https://docs.flutter.dev/platform-integration/platform-channels#pigeon">Platform Channels - Pigeon</a></p>
</body>
</html>
''';

  static const _docUrl =
      'https://docs.flutter.dev/platform-integration/platform-channels#pigeon';

  @override
  void initState() {
    super.initState();
    _webviewSupported = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.macOS);

    if (_webviewSupported) {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      _controller = WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) => setState(() => _status = '載入完成'),
            onWebResourceError: (error) {
              debugPrint(error.description);
              _controller?.loadHtmlString(_fallbackHtml);
              setState(() => _status = '載入失敗，已顯示離線備份');
            },
          ),
        )
        ..loadRequest(Uri.parse(_docUrl));

      if (WebViewPlatform.instance is AndroidWebViewPlatform) {
        AndroidWebViewController.enableDebugging(true);
      }
    } else {
      _status = '';
    }
  }

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('可讀性 Readable')),
      body: ListView(
        children: [
          Text.rich(
            TextSpan(
              text:
                  'Using this package eliminates the need to match strings between host and client for the names and data types of messages. '
                  'It supports nested classes, grouping messages into APIs, generation of asynchronous wrapper code, and sending messages in either direction. '
                  '',
              children: [
                TextSpan(
                  text: 'The generated code is readable ',
                  style: TextStyle(color: MyColors.highlight),
                ),
                const TextSpan(
                  text:
                      'and guarantees there are no conflicts between multiple clients of different versions.',
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('官方文件片段（內嵌 WebView）'),
          ),
          if (_webviewSupported && _controller != null) ...[
            if (_status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(_status, style: const TextStyle(color: Colors.grey)),
              ),
            SizedBox(height: 360, child: WebViewWidget(controller: _controller!)),
          ] else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('此平台不支援 WebView，或 WebView 載入失敗。'),
            ),
        ],
      ),
    );
  }
}
