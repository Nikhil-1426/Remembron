// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Firebase Image Upload',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ImageUploadScreen(),
//     );
//   }
// }

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();

//   Future getImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadImageToFirebase() async {
//     if (_image == null) {
//       print('No image selected.');
//       return;
//     }

//     try {
//       Reference storageReference = FirebaseStorage.instance
//           .ref()
//           .child('images/${DateTime.now().toString()}');
//       UploadTask uploadTask = storageReference.putFile(_image!);
//       TaskSnapshot snapshot = await uploadTask
//           .whenComplete(() => print('Image uploaded to Firebase'));
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       print('Download URL: $downloadUrl');
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image != null
//                 ? Image.file(
//                     _image!,
//                     height: 200,
//                   )
//                 : Text('No image selected.'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: getImage,
//               child: Text('Select Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: uploadImageToFirebase,
//               child: Text('Upload Image to Firebase'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Image Upload to Server',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ImageUploadScreen(),
//     );
//   }
// }

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();

//   Future getImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadImageToServer() async {
//     if (_image == null) {
//       print('No image selected.');
//       return;
//     }

//     try {
//       final url = 'http://192.168.117.72:5000/upload-image';
//       var request = http.MultipartRequest('POST', Uri.parse(url));
//       request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

//       var response = await request.send();
//       if (response.statusCode == 200) {
//         print('Image uploaded to server successfully');
//         // Handle response from the server
//         // For example, parse the JSON response
//         // var responseBody = await response.stream.bytesToString();
//         // print(responseBody);
//       } else {
//         print('Failed to upload image to server. Error ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error uploading image to server: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload to Server'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image != null
//                 ? Image.file(
//                     _image!,
//                     height: 200,
//                   )
//                 : Text('No image selected.'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: getImage,
//               child: Text('Select Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: uploadImageToServer,
//               child: Text('Upload Image to Server'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image Upload to Server',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveImageToLocalDirectory(_image!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveImageToLocalDirectory(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/selected_image.jpg';
    await imageFile.copy(imagePath);
    print('Image saved locally at: $imagePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload to Server'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                  )
                : Text('No image selected.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Select Image'),
            ),
          ],
        ),
      ),
    );
  }
}

