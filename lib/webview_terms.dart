import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Webview_terma extends StatefulWidget {
  String url;

  Webview_terma(this.url);

  @override
  _Webview_termaState createState() => _Webview_termaState();
}

class _Webview_termaState extends State<Webview_terma> {




  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url:"${widget.url}",

      allowFileURLs: true,

      appBar: new AppBar(
        backgroundColor: Color(0xff003680),

        title: const Text(""
            "efuel"),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.blue,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
