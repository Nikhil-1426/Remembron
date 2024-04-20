import 'package:flutter/material.dart';

class GeoFencingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 248, 141),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 178, 183, 176),
        title: Text("Geo Fencing", style: TextStyle(color: Colors.black, fontSize: 22)),
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
