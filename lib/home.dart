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
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        // pass
      });
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(
      source: ImageSource.camera,
    );
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Doc Help",
              textScaleFactor: 2,
            ),
            titleSpacing: 0.0,
            centerTitle: true,
            toolbarHeight: 150,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            elevation: 8.00,
            //backgroundColor: Color(0xFFFFA000),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal,
                    Colors.tealAccent,
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 2,
              tabs: [
                Tab(
                  icon: Icon(Icons.account_tree),
                  text: 'How to Use?',
                ),
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildPage2('How to Page'),
              buildPage1('Home Page'),
            ],
          ),
        ),
      );

  Widget buildPage1(String text) {
    return Scaffold(
      backgroundColor: Colors.white38,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Text("Covid and Pneumonia Detection",
                    style: TextStyle(
                      color: Color(0xFFE99600),
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                    )),
                SizedBox(height: 20),
                Center(
                  child: _loading
                      ? Container(
                          width: 200,
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/covid.png',
                                cacheHeight: 100,
                                cacheWidth: 100,
                              ),
                              SizedBox(height: 50),
                            ],
                          ))
                      : Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 150,
                                child: Image.file(_image),
                              ),
                              SizedBox(height: 20),
                              _output != null
                                  ? Text(
                                      '${_output[0]}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                ),
                Container(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(top: 1.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text('  ',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF26C6DA),
                                )),
                            new Text(
                              '',
                              style: new TextStyle(
                                  fontSize: 25.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF26C6DA)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => pickImage(),
                        child: Container(
                            width: 200,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 17,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFE99600),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("Take a photo",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20))),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => pickGalleryImage(),
                        child: Container(
                            width: 200,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 17,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFE99600),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("Select from the storage",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20))),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildPage2(String text) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Text("How To Use",
                    style: TextStyle(
                      color: Color(0xFFE99600),
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    )),
                SizedBox(height: 20),
                Center(
                    child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/howto.png',
                      cacheHeight: 100,
                      cacheWidth: 100,
                    ),
                    SizedBox(height: 25),
                  ],
                )),
                Container(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(top: 1.0),
                        child: new Text(
                          'Steps for Prediction - ',
                          style: new TextStyle(
                              fontSize: 25.0,
                              fontFamily: 'Roboto',
                              color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(top: 16.0),
                        child: new Row(
                          children: <Widget>[
                            new Text('  ',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF26C6DA),
                                )),
                          ],
                        ),
                      ),
                      new Text(
                          '1. Go to Home Tab.\n2. Select one option.\n    - Take a photo: Use camera to take photo of X-Ray.\n    - Select from storage: Use a saved image.\n\nYour Prediction result is ready.',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          )),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
