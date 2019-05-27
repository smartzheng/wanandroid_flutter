import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleDetailPage extends StatefulWidget {
  final String title;
  final String url;

  ArticleDetailPage({Key key, @required this.title, @required this.url}) : super(key: key);

  @override
  _ArticleDetailPageState createState() {
    return _ArticleDetailPageState();
  }
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isLoad = true;

  FlutterWebviewPlugin plugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    plugin.onStateChanged.listen((event) {
      setState(() {
        isLoad = (event.type != WebViewState.finishLoad);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var webView = WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
            child: isLoad
                ? LinearProgressIndicator()
                : Divider(
                    height: 0.1,
                    color: Theme.of(context).primaryColor,
                  ),
            preferredSize: Size.fromHeight(0.1)),
      ),
      withJavascript: true,
      withZoom: true,
      withLocalStorage: true
    );
    return webView;
  }
}
