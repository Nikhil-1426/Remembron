import 'package:flutter/material.dart';

class GeoFencingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 4, 53, 216),
        title: Text("Geo Fencing", style: TextStyle(color: Color.fromRGBO(252, 253, 252, 1), fontSize: 22)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Geo Fencing Page Content" ,style: TextStyle( fontSize: 18)),
            // Add your specific geo-fencing content here
          ],
        ),
      ),
    );
  }
}
