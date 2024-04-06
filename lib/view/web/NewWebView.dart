import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import 'webViewProvider.dart';


class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final List<String> websiteUrls = [
    "https://www.google.com/",
    "https://en.wikipedia.org/",
    "https://www.youtube.com/",
    "https://www.amazon.com/",
    "https://www.facebook.com/",
    "https://twitter.com/",
    "https://www.instagram.com/",
    "https://www.netflix.com/",
    "https://open.spotify.com/",
    "https://www.bbc.com/news"
  ];

  int _currentWebsiteIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadNextWebsiteWithDelay();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _loadNextWebsiteWithDelay() {
    const delay = Duration(seconds: 30); // Change the delay as needed
    _timer = Timer(delay, () {
      if (_currentWebsiteIndex < websiteUrls.length) {
        setState(() {
          _currentWebsiteIndex++;
        });
        _loadNextWebsiteWithDelay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Webview Demo"),
      ),
      body: _currentWebsiteIndex < websiteUrls.length
          ? _buildWebView(websiteUrls[_currentWebsiteIndex])
          : Center(
              child: Text("All websites loaded."),
            ),
    );
  }

  Widget _buildWebView(String url) {
    final countProvider = Provider.of<WebViewProvider>(context, listen: false);
    final controller = WebViewController();

    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (progress) => countProvider.setValue(progress / 100),
      onPageStarted: (url) {
        // Handle page started
      },
    ));

    controller.loadRequest(Uri.parse(url));
    return Stack(children: [
      WebViewWidget(controller: controller),
      Consumer<WebViewProvider>(
        builder: (context, value, child) {
          if (value.progress != 1) {
            //showToast(value.progress.toString());
            return Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: LinearProgressIndicator(value: value.progress)));
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          } else {
            return Container();
          }
        },
      )
    ]);
    // return Stack(
    //   children: [
    //     WebView(
    //       initialUrl: url,
    //       onWebViewCreated: (WebViewController webViewController) {
    //         controller = webViewController;
    //       },
    //       navigationDelegate: (NavigationRequest request) {
    //         // Handle navigation requests if needed
    //         return NavigationDecision.navigate;
    //       },
    //       onPageStarted: (String url) {
    //         // Handle page started
    //       },
    //       onPageFinished: (String url) {
    //         // Handle page finished
    //       },
    //       javascriptMode: JavascriptMode.unrestricted,
    //     ),
    //     Consumer<WebViewProvider>(
    //       builder: (context, value, child) {
    //         return Center(
    //           child: LinearProgressIndicator(value: value.progress),
    //         );
    //       },
    //     )
    //   ],
    // );
  }
}
