import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  List _output;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.3);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    return Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80),
            Text(
              'Predict Rock Paper Scissor by CNN',
              style: TextStyle(fontSize: 17, color: Colors.blueAccent),
            ),
            SizedBox(height: 50),
            Center(
              child: _loading
                  ? Container(
                      width: 250,
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/img-1.png'),
                          SizedBox(height: 50)
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 250,
                            child: Image.file(_image),
                          ),
                          SizedBox(height: 20),
                          _output != null
                              ? Text(
                                  '${_output[0]['label']}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )
                              : Container(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(children: <Widget>[
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Take a photo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: pickGalleryImage,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Camera Roll',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
