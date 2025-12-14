import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _highlightAndScroll() async {
    if (_controller == null) return;
    const script = r"""
(function() {
  const targetRegex = /The\s+generated\s+code\s+is\s+readable/gi;
  const paragraphs = Array.from(document.querySelectorAll('p'));
  for (const p of paragraphs) {
    if (!p.innerText) continue;
    if (!targetRegex.test(p.innerText)) {
      targetRegex.lastIndex = 0;
      continue;
    }
    targetRegex.lastIndex = 0;
    p.style.backgroundColor = '#fff8a6';
    p.style.color = 'black';
    // wrap matched segment (tolerate whitespace) with stronger highlight
    const regex = new RegExp(targetRegex.source, 'gi');
    p.innerHTML = p.innerHTML.replace(regex, function(m) {
      return '<span style="background:#ffeb3b;color:#000;font-weight:bold;">' + m + '</span>';
    });
    p.scrollIntoView({behavior: 'smooth', block: 'center'});
    break;
  }
})();
""";
    await _controller!.runJavaScript(script);
  }

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
            onPageFinished: (_) async {
              await _highlightAndScroll();
            },
            onWebResourceError: (error) {
              debugPrint(error.description);
              _controller?.loadHtmlString(_fallbackHtml);
            },
          ),
        )
        ..loadRequest(Uri.parse(_docUrl));

      if (WebViewPlatform.instance is AndroidWebViewPlatform) {
        AndroidWebViewController.enableDebugging(true);
      }
    }
  }

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  Future<void> _openUrl() async {
    final uri = Uri.parse(_docUrl);
    try {
      // 先嘗試使用 externalApplication，如果失敗則嘗試 platformDefault
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          // 如果 externalApplication 失敗，嘗試 platformDefault
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } else {
        // 如果 canLaunchUrl 返回 false，直接嘗試 launchUrl
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('無法打開連結: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('可讀性 Readable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: '在瀏覽器中打開',
            onPressed: _openUrl,
          ),
        ],
      ),
      body: Column(
        children: [
          // 上半部分：文字內容（可滾動）
          Expanded(
            flex: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    '官方文件片段（內嵌 WebView）',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 下半部分：WebView（獨立滾動）
          if (_webviewSupported && _controller != null)
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: WebViewWidget(controller: _controller!),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '此平台不支援 WebView，或 WebView 載入失敗。',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
