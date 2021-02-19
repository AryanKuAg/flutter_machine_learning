import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectorApp extends StatefulWidget {
  FaceDetectorApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FaceDetectorAppState createState() => _FaceDetectorAppState();
}

class _FaceDetectorAppState extends State<FaceDetectorApp> {
  File myImage;
  List<Face> faces;
  ui.Image image;

  pickImage({String from}) async {
    try {
      var yoImage;
      if (from == 'camera') {
        yoImage = await ImagePicker().getImage(source: ImageSource.camera);
      }
      if (from == 'gallery') {
        yoImage = await ImagePicker().getImage(source: ImageSource.gallery);
      }

      setState(() {
        this.myImage = File(yoImage.path);
        if (myImage != null) detectFaces();
      });
    } catch (e) {
      print('my favorite error is $e');
    }
  }

  loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        this.image = value;
      }),
    );
  }

  detectFaces() async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(this.myImage);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(
            mode: FaceDetectorMode.accurate,
            enableLandmarks: true,
            enableClassification: true));
    List<Face> detectedFaces = await faceDetector.processImage(visionImage);
    for (var i = 0; i < detectedFaces.length; i++) {
      final double smileProbability = detectedFaces[i].smilingProbability;
      print('smiling: $smileProbability');
    }
    faces = detectedFaces;
    loadImage(myImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (image != null)
              FittedBox(
                  child: SizedBox(
                width: image.width.toDouble(),
                height: image.height.toDouble(),
                child: CustomPaint(
                  painter: FacePainter(image, faces),
                ),
              )),
            Text('Pick An Image'),
            RaisedButton(
              child: Text('Camera'),
              onPressed: () => pickImage(from: 'camera'),
            ),
            RaisedButton(
              child: Text('Gallery'),
              onPressed: () => pickImage(from: 'gallery'),
            ),
          ],
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  ui.Image image;
  List<Face> faces;
  List<Rect> rects = [];
  FacePainter(ui.Image img, List<Face> faces) {
    this.image = img;
    this.faces = faces;
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = Colors.red;
    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
