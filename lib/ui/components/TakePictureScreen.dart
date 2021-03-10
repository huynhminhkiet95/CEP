import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Stack(
        children: <Widget>[
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   child: null,
          //   color: Colors.blue,
          // ),
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 150,
                color: Colors.black.withOpacity(0.1),
                child: InkWell(
                     onTap: () async {
                          // Take the Picture in a try / catch block. If anything goes wrong,
                          // catch the error.
                          try {
                            // Ensure that the camera is initialized.
                            await _initializeControllerFuture;

                            // Construct the path where the image should be saved using the
                            // pattern package.
                            final path = join(
                              // Store the picture in the temp directory.
                              // Find the temp directory using the `path_provider` plugin.
                              (await getTemporaryDirectory()).path,
                              '${DateTime.now()}.png',
                            );
                            print({"85": path});

                            // await FlutterExifRotation.rotateImage(path:path);
                            // Attempt to take a picture and log where it's been saved.
                            await _controller.takePicture(path);
                            print({"89": path});
                            print({"90": File(path)});
                            // File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                            // image = FlutterExifRotation.rotateAndSaveImage(path: path);
                            // If the picture was taken, display it on a new screen.
                            Navigator.of(context).pop(path);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => DisplayPictureScreen(imagePath: path),
                            //   ),
                            // );
                          } catch (e) {
                            // If an error occurs, log the error to the console.
                            print(e);
                          }
                        },
                  child: Container(
                      // color:Colors.white,
                      child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 65,
                          height: 65,
                          child: null,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: null,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
          child: PhotoView(
        imageProvider: FileImage(File(imagePath)),
      )),
      //  Container(
      //   height:  MediaQuery.of(context).size.height,
      //   width:  MediaQuery.of(context).size.width,
      //   child:
      //   RotatedBox(
      //     quarterTurns: 5,
      //     child: Image.file(File(imagePath)))),
    );
  }
}
