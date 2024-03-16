import 'package:flutter/material.dart';

class ConvLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation Log"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Conversation Log Page Content"),
            // Add your specific conversation log content here
          ],
        ),
      ),
    );
  }
}
