// import 'dart:async'; // Import async library for Timer
// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:video_player/video_player.dart';

// class RecognizePage extends StatefulWidget {
//   @override
//   _RecognizePageState createState() => _RecognizePageState();
// }

// class _RecognizePageState extends State<RecognizePage> {
//   File? _image;
//   File? _video;
//   late Timer _videoTimer;
//   bool _isUploading = false;
//   String _uploadStatus = '';

//   Future<void> _pickImage() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> _takePicture() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.camera);
//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> _takeVideo() async {
//     final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.camera);
//     if (pickedVideo != null) {
//       setState(() {
//         _video = File(pickedVideo.path);
//       });

//       _videoTimer = Timer(Duration(seconds: 9), () {
//         setState(() {
//           _video = null; // Stop video recording after 9 seconds
//         });
//       });

//       print('Video recording started.');
//       print('Current time: ${DateTime.now()}');

//       // Check video format (Android only)
//       if (Platform.isAndroid) {
//         final videoPlayerController = VideoPlayerController.file(_video!);
//         await videoPlayerController.initialize();

//         // Check if the video has a size
//         final size = videoPlayerController.value.size;
//         if (size == null) {
//           print('Warning: Unable to load video.');
//           // Show user a message about the error
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to load video. Please try again.'),
//             ),
//           );
//         } else {
//           print('Video loaded successfully.');
//         }

//         videoPlayerController.dispose(); // Dispose the controller after use
//       }
//     }
//   }

//   Future<void> _uploadImage() async {
//     if (_image == null) {
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       _uploadStatus = 'Uploading...';
//     });

//     try {
//       // Create a reference to the Firebase Storage bucket
//       final storageRef = FirebaseStorage.instance.ref();
//       final imageRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

//       // Upload the image file
//       final uploadTask = imageRef.putFile(
//         _image!,
//         SettableMetadata(contentType: 'image/jpeg'),
//       );

//       // Wait for the upload to complete
//       final snapshot = await uploadTask;
//       final downloadUrl = await snapshot.ref.getDownloadURL();

//       setState(() {
//         _isUploading = false;
//         _uploadStatus = 'Upload complete! Download URL: $downloadUrl';
//       });

//       print('Image uploaded successfully! Download URL: $downloadUrl');
//     } catch (e) {
//       setState(() {
//         _isUploading = false;
//         _uploadStatus = 'Failed to upload image: $e';
//       });

//       print('Failed to upload image: $e');
//     }
//   }

//   Future<void> _uploadVideo() async {
//     if (_video == null) {
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       _uploadStatus = 'Uploading...';
//     });

//     try {
//       // Create a reference to the Firebase Storage bucket
//       final storageRef = FirebaseStorage.instance.ref();
//       final videoRef = storageRef.child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');

//       // Upload the video file
//       final uploadTask = videoRef.putFile(
//         _video!,
//         SettableMetadata(contentType: 'video/mp4'),
//       );

//       // Wait for the upload to complete
//       final snapshot = await uploadTask;
//       final downloadUrl = await snapshot.ref.getDownloadURL();

//       setState(() {
//         _isUploading = false;
//         _uploadStatus = 'Upload complete! Download URL: $downloadUrl';
//       });

//       print('Video uploaded successfully! Download URL: $downloadUrl');
//     } catch (e) {
//       setState(() {
//         _isUploading = false;
//         _uploadStatus = 'Failed to upload video: $e';
//       });

//       print('Failed to upload video: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 195, 248, 141),
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 178, 183, 176),
//         title: Text('Recognize Page', style: TextStyle(color: Colors.black, fontSize: 22)),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image == null && _video == null
//                 ? Text('No media selected', style: TextStyle(fontSize: 20)) // Increased text size to 16
//                 : _image != null
//                     ? Image.file(_image!)
//                     : Text('Video selected.', style: TextStyle(fontSize: 13)),
//             SizedBox(height: 15),
//             if (_isUploading) CircularProgressIndicator(),
//             if (_uploadStatus.isNotEmpty) Text(_uploadStatus),
//             SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: _takePicture,
//                   child: Text('Recognize', style: TextStyle(fontSize: 13, color : Colors.black)),
//                   style: ButtonStyle(
//                     minimumSize: MaterialStateProperty.all<Size>(Size(150, 35)),
//                     backgroundColor: MaterialStateProperty.all(
//                         Color.fromARGB(255, 178, 183, 176)) // Adjust button size here
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _uploadImage,
//                   child: Text('Upload Image', style: TextStyle(fontSize: 13, color : Colors.black)),
//                   style: ButtonStyle(
//                     minimumSize: MaterialStateProperty.all<Size>(Size(150, 35)),
//                     backgroundColor: MaterialStateProperty.all(
//                         Color.fromARGB(255, 178, 183, 176)) // Adjust button size here
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: _takeVideo,
//                   child: Text('Add a Face', style: TextStyle(fontSize: 13, color : Colors.black) ),
//                   style: ButtonStyle(
//                     minimumSize: MaterialStateProperty.all<Size>(Size(150, 35)),
//                     backgroundColor: MaterialStateProperty.all(
//                         Color.fromARGB(255, 178, 183, 176)) // Adjust button size here
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _uploadVideo,
//                   child: Text('Update Video', style: TextStyle(fontSize: 13, color : Colors.black)),
//                   style: ButtonStyle(
//                     minimumSize: MaterialStateProperty.all<Size>(Size(150, 35)),
//                     backgroundColor: MaterialStateProperty.all(
//                         Color.fromARGB(255, 178, 183, 176)) // Adjust button size here
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Cancel the timer when the widget is disposed
//     _videoTimer.cancel();
//     super.dispose();
//   }
// }






import 'dart:async'; // Import async library for Timer
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class RecognizePage extends StatefulWidget {
  @override
  _RecognizePageState createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  File? _image;
  File? _video;
  late Timer _videoTimer;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _takePicture() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _takeVideo() async {
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pickedVideo != null) {
      setState(() {
        _video = File(pickedVideo.path);
      });

      _videoTimer = Timer(Duration(seconds: 9), () {
        setState(() {
          _video = null; // Stop video recording after 9 seconds
        });
      });

      print('Video recording started.');
      print('Current time: ${DateTime.now()}');

      // Check video format (Android only)
      if (Platform.isAndroid) {
        final videoPlayerController = VideoPlayerController.file(_video!);
        await videoPlayerController.initialize();

        // Check if the video has a size
        final size = videoPlayerController.value.size;
        if (size == null) {
          print('Warning: Unable to load video.');
          // Show user a message about the error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load video. Please try again.'),
            ),
          );
        } else {
          print('Video loaded successfully.');
        }

        videoPlayerController.dispose(); // Dispose the controller after use
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    // Firebase Storage code
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the image URL
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image uploaded successfully!')),
    );

    print('Image URL: $imageUrl');
  }

  Future<void> _uploadVideoMetadata(String videoUrl) async {
    DatabaseReference ref = FirebaseDatabase(databaseURL: 'https://remembron-default-rtdb.asia-southeast1.firebasedatabase.app').reference().child('videos');
    await ref.push().set({
      'videoUrl': videoUrl,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _uploadVideo() async {
    if (_video == null) {
      return;
    }

    // Firebase Storage code
    String fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_video!);
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the video URL
    String videoUrl = await taskSnapshot.ref.getDownloadURL();

    // Upload video metadata to Realtime Database
    await _uploadVideoMetadata(videoUrl);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Video uploaded successfully!')),
    );

    print('Video URL: $videoUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 218, 218),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
        title: Text('Recognize Page', style: TextStyle(color: Color.fromARGB(179, 251, 236, 236), fontSize: 22)),
        iconTheme : IconThemeData(
          color: Color.fromARGB(179, 251, 236, 236), // Set the back button color
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null && _video == null
                ? Text('No media selected', style: TextStyle(fontSize: 20)) // Increased text size to 16
                : _image != null
                    ? Image.file(_image!)
                    : Text('Video selected.', style: TextStyle(fontSize: 13)),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  child: Text('Recognize', style: TextStyle(fontSize: 13, color : Colors.black)),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(210, 233, 175, 74)) // Adjust button size here
                  ),
                ),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text('Upload Image', style: TextStyle(fontSize: 13, color : Colors.black)),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(210, 233, 175, 74)) // Adjust button size here
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _takeVideo,
                  child: Text('Add a Face', style: TextStyle(fontSize: 13, color : Colors.black) ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(210, 233, 175, 74)) // Adjust button size here
                  ),
                ),
                ElevatedButton(
                  onPressed: _uploadVideo,
                  child: Text('Update Video', style: TextStyle(fontSize: 13, color : Colors.black)),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(210, 233, 175, 74)) // Adjust button size here
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _videoTimer.cancel();
    super.dispose();
  }
}

