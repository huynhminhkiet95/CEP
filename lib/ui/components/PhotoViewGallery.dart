import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PreviewPhotoGallery extends StatelessWidget {
  final List<String> imageList;
  final indexItem;
  PreviewPhotoGallery({this.imageList, this.indexItem});
  @override
  Widget build(BuildContext context) {
// FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        sized: false,
        child: Scaffold(
//        appBar: new AppBar(
//   // title: new Text("widget.title"),
//   brightness: Brightness.light, // or use Brightness.dark
// ),
          // add this body tag with container and photoview widget
          body: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  child: PhotoViewGallery.builder(
                    itemCount: imageList.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: getImage(imageList[index]),
                        minScale: PhotoViewComputedScale.contained * 0.9,
                        maxScale: PhotoViewComputedScale.covered * 3,
                        initialScale: PhotoViewComputedScale.contained * 0.9,
                      );
                    },
                    scrollPhysics: BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    

                    pageController: PageController(initialPage: indexItem),
                    enableRotation: false,
                    loadingChild: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                )
              ],
            ),
          ),
        ));
  }
  ImageProvider getImage(url)
  {
    if (url.substring(0, 5) == "https") {
      return  NetworkImage(url);
    }
    
    return FileImage(File(url));
  }
}
