import 'dart:async';
import 'package:camera/camera.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'DisplayPictureScreen.dart';
import 'WebViewPlugin.dart';

class TakePhoto extends StatefulWidget {
  final CameraDescription camera;
  final String itemId;
  final String url;
  final BuildContext currentContext;
  const TakePhoto({
    Key key,
    @required this.camera,
    this.itemId,
    this.currentContext,
    this.url,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePhoto> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isLoading = false;
  String name;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorConstants.yellowColor,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.photo_library),
              tooltip: 'Choose gallery',
              onPressed: () => _openGalery(context),
            ),
            Container(
              width: 5,
            )
          ],
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                //Navigator.pushReplacementNamed(context, '/webview');
                // Navigator.pushReplacement(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (context) => WebViewPlugin(
                //             title: widget.itemId, url: widget.url)));
              })),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return new AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: new CameraPreview(_controller),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.yellowColor,
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            name =
                formatDate(DateTime.now(), [yyyy, mm, dd, HH, nn, ss]) + '.png';
            final path = join(
              (await getTemporaryDirectory()).path,
              name,
            );
            await _controller.takePicture(path);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: path,
                  name: name,
                  itemId: widget.itemId,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _openGalery(context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        name = formatDate(DateTime.now(), [yyyy, mm, dd, HH, nn, ss]) + '.png';
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: image.path,
            name: name,
            itemId: widget.itemId,
          ),
        ),
      );
    }
  }
}
