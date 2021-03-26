import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewContainer extends StatefulWidget {
  final url;
  final name;

  WebViewContainer(this.url, this.name);
  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();
  List<CameraDescription> cameras;
  void loadCamera() async {
    cameras = await availableCameras();
  }

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  _WebViewContainerState(this._url);
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.yellowColor,
          title: Text(widget.name),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.camera_alt),
              tooltip: 'Take photo',
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return TakePictureScreen(
                //     camera: cameras.first,
                //     itemId: widget.name,
                //   );
                // }));
              },
            ),
            Container(
              width: 5,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: _url,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ))
          ],
        ));
  }
}
