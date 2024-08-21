import 'package:flutter/material.dart';

class RecognizePage extends StatefulWidget {
  @override
  _RecognizePageState createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 218, 218),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
        title: Text(
          'Recognize Page',
          style: TextStyle(
            color: Color.fromARGB(179, 251, 236, 236),
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(
          color: Color.fromARGB(179, 251, 236, 236), // Set the back button color
        ),
      ),
      body: Container(), // Blank body
    );
  }
}

