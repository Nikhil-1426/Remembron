import 'package:flutter/material.dart';

class GeoFencingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geo Fencing"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Geo Fencing Page Content"),
            // Add your specific geo-fencing content here
          ],
        ),
      ),
    );
  }
}
