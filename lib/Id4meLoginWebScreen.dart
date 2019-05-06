import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Id4meLoginWebScreen extends StatefulWidget {
  final String url;

  Id4meLoginWebScreen(this.url);

  @override
  _Id4meLoginWebScreenState createState() => new _Id4meLoginWebScreenState();
}

class _Id4meLoginWebScreenState extends State<Id4meLoginWebScreen> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setUpWebView();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(url: widget.url);
  }

  void setUpWebView() {
    flutterWebViewPlugin.close();

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      setState(() {
        if (mounted) {
          if (url.startsWith("https://id4meredirect.com")) {
            RegExp regExp = new RegExp("(code=)(.*)&state");
            String code = regExp.firstMatch(url)?.group(2);

            Navigator.pop(context, code);
          }
        }
      });
    });
  }
}
