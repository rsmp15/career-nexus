import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // We only initialize the controller if we're NOT on web.
    // Webview_flutter's web implementation has limited feature parity and often throws UnimplementedError.
    if (!kIsWeb && _controller == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final url = args?['url'] ?? 'https://humanbenchmark.com';

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(AppTheme.background)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() => _isLoading = true);
            },
            onPageFinished: (String url) {
              setState(() => _isLoading = false);
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    } else if (kIsWeb) {
      _isLoading = false;
    }
  }

  void _openExternally() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final url = args?['url'] ?? 'https://humanbenchmark.com';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Career Nexus"),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.textPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openExternally,
            tooltip: "Open in Browser",
          ),
          if (!kIsWeb && _controller != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller!.reload(),
            ),
        ],
      ),
      body: kIsWeb ? _buildWebFallback() : _buildMobileWebView(),
    );
  }

  Widget _buildMobileWebView() {
    if (_controller == null)
      return const Center(child: CircularProgressIndicator());
    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildWebFallback() {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final url = args?['url'] ?? 'https://humanbenchmark.com';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.language, size: 80, color: AppTheme.secondary),
            const SizedBox(height: 24),
            Text(
              "External Assessment Required",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "HumanBenchmark.com requires a direct browser connection for accurate scores and security purposes.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _openExternally,
              icon: const Icon(Icons.open_in_new),
              label: const Text("Launch Assessment Tool"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Return to App"),
            ),
          ],
        ),
      ),
    );
  }
}
