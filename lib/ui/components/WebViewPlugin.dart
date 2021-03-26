// import 'package:camera/camera.dart';
// import 'package:date_format/date_format.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:CEPmobile/config/colors.dart';
// import 'package:CEPmobile/ui/components/DisplayPictureScreen.dart';
// import 'package:image_picker/image_picker.dart';

// import 'ModalProgressHUDCustomize.dart';
// import 'TakePhoto.dart';

// class WebViewPlugin extends StatefulWidget {
//   final String title;
//   final String url;
//   final String type;
//   WebViewPlugin({this.title, this.url, this.type});
//   @override
//   NewWeb createState() => NewWeb();
// }

// class NewWeb extends State<WebViewPlugin> {
//   // Instance of WebView plugin
//   var flutterWebViewPlugin = new FlutterWebviewPlugin();
//   List<CameraDescription> cameras;
//   void loadCamera() async {
//     cameras = await availableCameras();
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadCamera();
//     flutterWebViewPlugin.close();
//   }

//   @override
//   void dispose() {
//     flutterWebViewPlugin.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WebviewScaffold(
//       url: widget.url,
//       appBar: AppBar(
//         backgroundColor:
//             Color(ColorConstants.getColorHexFromStr(ColorConstants.backgroud)),
//         title: Text(widget.title),
//         leading: new IconButton(
//             icon: new Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//       ),
//       withZoom: true,
//       withLocalStorage: true,
//       hidden: true,
//       initialChild: Container(
//         color: Colors.transparent,
//         child: Center(
//           child: Container(
//             width: 200.0,
//             height: 100.0,
//             alignment: AlignmentDirectional.center,
//             decoration: new BoxDecoration(
//                 color: Colors.green.withOpacity(0.8),
//                 borderRadius: new BorderRadius.circular(10.0)),
//             child: new Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 new CircularProgressIndicator(
//                   strokeWidth: 3.0,
//                   valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//                 new Divider(
//                   height: 10,
//                   color: Color(0x00000000),
//                 ),
//                 new Text(
//                   "Loading...",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
   
//     );
//   }

//   void openList(BuildContext context) {
//     Navigator.pushReplacement(
//         context,
//         new MaterialPageRoute(
//             builder: (context) => TakePhoto(
//                 camera: cameras.first,
//                 itemId: widget.title,
//                 currentContext: context,
//                 url: widget.url)));
//   }

//   Future getImage(String itemId) async {
//     var image = await ImagePicker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DisplayPictureScreen(
//               imagePath: image.path,
//               name: formatDate(DateTime.now(), [yyyy, mm, dd, HH, nn, ss]) +
//                   '.png',
//               itemId: itemId,
//               url: widget.url),
//         ),
//       );
//     }
//   }
// }
