import 'dart:async'; // Import async library for Timer
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:video_player/video_player.dart';

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

    // Encode image to base64 string
    List<int> imageBytes = await _image!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Send HTTP POST request to server
    String url =
        'http://172.16.41.231:3000/upload'; // Replace with your server URL
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = json.encode({'imageData': base64Image});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<void> _uploadVideo() async {
  if (_video == null) {
    return;
  }

  String url = 'http://172.16.41.231:3000/uploadVideo';
  var request = http.MultipartRequest('POST', Uri.parse(url));

  // Add the video file with content type
  request.files.add(await http.MultipartFile.fromPath(
    'video',
    _video!.path,
    contentType: MediaType('video', 'mp4'), // Specify the content type
  ));

  var response = await request.send();

  if (response.statusCode == 200) {
    print('Video uploaded successfully!');
  } else {
    print('Failed to upload video. Status code: ${response.statusCode}');
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.lightBlue,
    appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 4, 53, 216),
      title: Text('Recognize Page', style: TextStyle(color: Color.fromRGBO(252, 253, 252, 1), fontSize: 22)),
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
                child: Text('Recognize', style: TextStyle(fontSize: 13)),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(120, 30)), // Adjust button size here
                ),
              ),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload Image', style: TextStyle(fontSize: 13)),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(120, 30)), // Adjust button size here
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
                child: Text('Add a Face', style: TextStyle(fontSize: 13)),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(120, 30)), // Adjust button size here
                ),
              ),
              ElevatedButton(
                onPressed: _uploadVideo,
                child: Text('Update Video', style: TextStyle(fontSize: 13)),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(120, 30)), // Adjust button size here
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
