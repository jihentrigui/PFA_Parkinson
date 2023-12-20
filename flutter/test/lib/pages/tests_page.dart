// tests_page.dart

import 'package:flutter/material.dart';
import 'package:test/pages/drawing_page.dart';

class TestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a Test'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Add your divisions with images here
          // Example:
          TestOption(imagePath: 'lib/images/8.png', testName: 'Test 1',),
          TestOption(imagePath: 'lib/images/eclipse.png', testName: 'Test 2',),
          TestOption(imagePath: 'lib/images/l.png', testName: 'Test 3',),
          TestOption(imagePath: 'lib/images/lolo.png', testName: 'Test 4',),
          TestOption(imagePath: 'lib/images/spiral.png', testName: 'Test 5',),
        // Add more TestOption widgets as needed
        ],
      ),
     
    );
  }
}

class TestOption extends StatelessWidget {
   final String imagePath;
  final String testName;

  TestOption({required this.imagePath, required this.testName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the DrawingPage when a test is selected
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DrawingPage(testName: testName)),
        );
      },
      child: Card(
        child: Column(
          children: [
            Image.asset(imagePath),
            Text(testName),
          ],
        ),
      ),
    );
  }
}
