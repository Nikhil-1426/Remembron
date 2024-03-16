import 'dart:async';
import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Import your auth screen file

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Initialize fade-in animation
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the animation when the screen is loaded
    _controller.forward();

    // Simulate a loading period, then navigate to AuthScreen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Loading image at the center with fade-in animation
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 - 180,
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                width: 500,
                height: 500,
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
          // Loading indicator centered between the image and notification box
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 + 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // Notification box at the bottom
          Positioned(
            bottom: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(89, 95, 94, 94).withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Hang tight, it may take a few seconds to load.",
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: "AIzaSyD7Ik5cHo5hkFwzjy8mnnzOLWk3aDv4i8g",
//       authDomain: "remembron.firebaseapp.com",
//       projectId: "remembron",
//       storageBucket: "remembron.appspot.com",
//       messagingSenderId: "91319881411",
//       appId: "1:91319881411:android:c1998c93eb3f74b4005c76",
//     ),
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Your App Title',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoadingScreen(),
//     );
//   }
// }

// class LoadingScreen extends StatefulWidget {
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllerFuture = _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;

//     _controller = CameraController(
//       firstCamera,
//       ResolutionPreset.medium,
//     );

//     return _controller.initialize().then((_) {
//       // Camera initialization successful
//     }).catchError((error) {
//       // Handle initialization errors
//       print('Error initializing camera: $error');
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _takePicture() async {
//     try {
//       await _initializeControllerFuture;

//       XFile picture = await _controller.takePicture();

//       Reference storageRef = FirebaseStorage.instance
//           .ref()
//           .child('Uploaded images/${DateTime.now()}.jpg');
//       await storageRef.putFile(File(picture.path));

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Image uploaded successfully!'),
//         ),
//       );
//     } catch (e) {
//       print('Error capturing/uploading image: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error capturing/uploading image. Please try again.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Capture and Upload Image'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _takePicture,
//         child: Icon(Icons.camera),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as Path;

// class LoadingScreen extends StatefulWidget {
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   File? _image;
//   final picker = ImagePicker();

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadImageToFirebase(BuildContext context) async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('No image selected.'),
//         ),
//       );
//       return;
//     }

//     String fileName = Path.basename(_image!.path);
//     Reference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child(fileName);
//     UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
//     await uploadTask.whenComplete(() => null);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Image uploaded successfully'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recognize Image'),
//       ),
//       body: Center(
//         child: _image == null
//             ? Text('No image selected.')
//             : Image.file(_image!),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           FloatingActionButton(
//             onPressed: getImage,
//             tooltip: 'Pick Image',
//             child: Icon(Icons.add_a_photo),
//           ),
//           SizedBox(height: 16),
//           FloatingActionButton(
//             onPressed: () {
//               uploadImageToFirebase(context);
//             },
//             tooltip: 'Upload Image',
//             child: Icon(Icons.cloud_upload),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class LoadingScreen extends StatefulWidget {
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<Uri?> uploadPic() async {
//     // Get the file from the image picker and store it
//     XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (image == null) {
//       // No image selected
//       return null;
//     }

//     // Create a reference to the location you want to upload to in Firebase
//     Reference reference = _storage.ref().child("images/${DateTime.now()}.jpg");

//     // Upload the file to Firebase
//     UploadTask uploadTask = reference.putFile(File(image.path));

//     // Wait for the upload task to complete
//     TaskSnapshot snapshot = await uploadTask;

//     // Retrieve the download URL
//     String downloadUrl = await snapshot.ref.getDownloadURL();

//     // Convert the string URL to a Uri object and return it
//     return Uri.parse(downloadUrl);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recognize Image'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             Uri? downloadUrl = await uploadPic();
//             if (downloadUrl != null) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Image uploaded successfully'),
//                 ),
//               );
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('No image selected.'),
//                 ),
//               );
//             }
//           },
//           child: Text('Upload Image'),
//         ),
//       ),
//     );
//   }
// }







