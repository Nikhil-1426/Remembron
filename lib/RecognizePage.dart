import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class RecognizePage extends StatefulWidget {
  @override
  _RecognizePageState createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  final ImagePicker _picker = ImagePicker();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  String _recognizedName = '';
  String _recognizedRelation = '';
  final List<Map<String, dynamic>> _registeredFaces = [];

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _registerPerson() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final filePath = image.path;
      final inputImage = InputImage.fromFilePath(filePath);

      // Run face detection
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController relationController = TextEditingController();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enter Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: relationController,
                      decoration: InputDecoration(
                        labelText: 'Relation',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _registeredFaces.add({
                        'filePath': filePath,
                        'name': nameController.text,
                        'relation': relationController.text,
                        'faces': faces.map((face) => _extractFaceData(face)).toList(),
                      });
                    });
                    print('Face registered successfully');
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      } else {
        print('No face detected in the image');
      }
    }
  }

  Future<void> _recognizePerson() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final filePath = image.path;
      final inputImage = InputImage.fromFilePath(filePath);

      // Run face detection
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final matchedFace = _registeredFaces.firstWhere(
              (registeredFace) => _isFaceMatching(registeredFace['faces'], faces),
          orElse: () => {'name': 'Face not recognized', 'relation': ''},
        );

        setState(() {
          _recognizedName = matchedFace['name'];
          _recognizedRelation = matchedFace['relation'];
        });
      } else {
        setState(() {
          _recognizedName = 'No face detected';
          _recognizedRelation = '';
        });
      }
    }
  }

  Map<String, double> _extractFaceData(Face face) {
    return {
      'left': face.boundingBox.left,
      'top': face.boundingBox.top,
      'right': face.boundingBox.right,
      'bottom': face.boundingBox.bottom,
      'width': face.boundingBox.width,
      'height': face.boundingBox.height,
    };
  }

  bool _isFaceMatching(List<Map<String, double>> registeredFaces, List<Face> detectedFaces) {
    for (var registeredFace in registeredFaces) {
      for (var detectedFace in detectedFaces) {
        final detectedFaceData = _extractFaceData(detectedFace);

        // Basic matching based on bounding box overlap
        if (_isBoundingBoxOverlap(registeredFace, detectedFaceData)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isBoundingBoxOverlap(Map<String, double> registeredFace, Map<String, double> detectedFace) {
    final rLeft = registeredFace['left']!;
    final rTop = registeredFace['top']!;
    final rRight = registeredFace['right']!;
    final rBottom = registeredFace['bottom']!;

    final dLeft = detectedFace['left']!;
    final dTop = detectedFace['top']!;
    final dRight = detectedFace['right']!;
    final dBottom = detectedFace['bottom']!;

    // Check if the bounding boxes overlap
    return !(rRight < dLeft || rLeft > dRight || rBottom < dTop || rTop > dBottom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
        title: Text(
          'Recognize Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color.fromARGB(240, 44, 91, 91), width: 2), // Outline color and width
                borderRadius: BorderRadius.circular(8.0), // Corner radius
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add_a_photo, color: Color.fromARGB(240, 44, 91, 91)),
                    title: Text('Register Person', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      ElevatedButton.icon(
                        onPressed: _registerPerson,
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        label: Text('Register', style: TextStyle(fontSize: 16, color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color.fromARGB(240, 44, 91, 91), width: 2), // Outline color and width
                borderRadius: BorderRadius.circular(8.0), // Corner radius
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.face, color: Color.fromARGB(240, 44, 91, 91)),
                    title: Text('Recognize Person', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      ElevatedButton.icon(
                        onPressed: _recognizePerson,
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        label: Text('Recognize', style: TextStyle(fontSize: 16, color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color.fromARGB(240, 44, 91, 91), width: 2), // Outline color and width
                borderRadius: BorderRadius.circular(8.0), // Corner radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Name: $_recognizedName',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Relation: $_recognizedRelation',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
