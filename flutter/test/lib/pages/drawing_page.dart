// drawing_page.dart

import 'package:flutter/material.dart';

class DrawingPage extends StatelessWidget {
  final String testName;

  DrawingPage({required this.testName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw ${testName}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can add drawing-related widgets here
            Text('This is where the user can draw ${testName}'),
          ],
        ),
      ),
    );
  }
}
