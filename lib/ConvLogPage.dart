import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ConvLogPage extends StatefulWidget {
  @override
  _ConvLogPageState createState() => _ConvLogPageState();
}

class _ConvLogPageState extends State<ConvLogPage> {
  FlutterSoundRecorder? _audioRecorder = FlutterSoundRecorder();
  String? _recordingPath;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder!.openAudioSession().then((value) {});
  }

  @override
  void dispose() {
    _audioRecorder!.closeAudioSession();
    super.dispose();
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
    });

    // Start recording
    await _audioRecorder!.startRecorder(toFile: 'tempAudio');

    // Start a timer to stop recording after one minute
    Timer(Duration(minutes: 1), () async {
      await _stopRecording();
    });
  }

  Future<void> _stopRecording() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    String filePath = '${appDocDir.path}/${_recordingPath}.aac';
    File file = File(filePath);
    if (file.existsSync()) {
      try {
        final Reference storageReference =
            FirebaseStorage.instance.ref('https://console.firebase.google.com/u/0/project/remembron/storage/remembron.appspot.com/files/~2Faudio_files').child('audio_files/${DateTime.now()}.aac');
        final UploadTask uploadTask = storageReference.putFile(file);
        // Properly handle the completion of the uploadTask
        await uploadTask;
        print('File uploaded successfully');
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 4, 53, 216),
        title: Text('Conversation Log Page', style: TextStyle(color: Color.fromRGBO(252, 253, 252, 1), fontSize: 20)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRecording) ...[
              Text('Recording...'),
              ElevatedButton(
                onPressed: _stopRecording,
                child: Text('Stop Recording'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: _startRecording,
                child: Text('Start Recording'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}




