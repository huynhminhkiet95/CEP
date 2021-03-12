// A Widget that displays the picture taken by the user
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:CEPmobile/config/colors.dart';
import 'package:CEPmobile/dtos/common/uploaddocument.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../GlobalUser.dart';
import 'WebViewPlugin.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String name;
  final String itemId;
  final String url;

  DisplayPictureScreen(
      {Key key, this.imagePath, this.name, this.itemId, this.url})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  GlobalKey _globalKey = new GlobalKey();
  CommonService _commonService;
  _DisplayPictureScreenState();
  bool isSave = true;

  @override
  void initState() {
    final services = Services.of(context);
    _commonService = services.commonService;
    super.initState();
  }

  _saved(File file) async {
    try {
      setState(() {
        isSave = false;
      });

      String base64Image = base64Encode(file.readAsBytesSync());

      UploadDocumentEntry uploadDocumentEntry = new UploadDocumentEntry();
      uploadDocumentEntry.fileName = widget.name;
      uploadDocumentEntry.userId = globalUser.getUserId;

      uploadDocumentEntry.stringData = base64Image;
      uploadDocumentEntry.refNoValue = widget.itemId;
      if (widget.url == null) {
        uploadDocumentEntry.refNoType = "EORD";
        uploadDocumentEntry.docRefType = "EXORD";
      } else {
        uploadDocumentEntry.refNoType = "TRIP";
        uploadDocumentEntry.docRefType = "TRIPD";
      }

      var response = await _commonService.uploadDocument(
          uploadDocumentEntry, globalUser.getSubsidiaryId);
      setState(() {
        isSave = true;
      });
      if (response.statusCode == 200) {
        var dataJson = json.decode(response.body);
        if (dataJson["IsSuccess"] == true) {
          Fluttertoast.showToast(
              msg: "Upload success!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0);
          if (widget.url == null) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        WebViewPlugin(title: widget.itemId, url: widget.url)));
          }
        } else {
          Fluttertoast.showToast(
              msg: response.body,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
          backgroundColor: ColorConstants.yellowColor,
          title: Text(widget.name),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                if (widget.url == null) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => WebViewPlugin(
                              title: widget.itemId, url: widget.url)));
                }
              })),
      body: FutureBuilder<File>(
        future: _getLocalFile(widget.imagePath),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ModalProgressHUD(
                color: ColorConstants.whiteColor,
                inAsyncCall: !isSave ?? false,
                child: Image.file(snapshot.data));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.yellowColor,
        child: Icon(
          Icons.save,
        ),
        onPressed: () async {
          if (isSave) _saved(File(widget.imagePath));
        },
      ),
    );
  }

  Future<String> get getPath async {
    final String version = widget.imagePath;
    return version;
  }

  Future<File> _getLocalFile(String filename) async {
    File file = File(widget.imagePath);
    return file;
  }
}
