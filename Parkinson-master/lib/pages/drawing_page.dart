import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';
import 'package:image/image.dart' as img;
// import 'package:cloud_firestore/cloud_firestore.dart';

class DrawingPage extends StatefulWidget {
  final String testName;
  final String testImagePath;

  const DrawingPage(
      {Key? key, required this.testName, required this.testImagePath});

  @override
  DrawingPageState createState() => DrawingPageState();
}

class DrawingPageState extends State<DrawingPage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  List<List<Map<String, dynamic>>> drawingsData = [];

  bool isDrawing = false;
  Timer? drawingTimer;
   int drawingCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dessinez ${widget.testName}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Listener(
                onPointerDown: (PointerDownEvent event) {
                  setState(() {
                    isDrawing = true;
                  });
                      _startDrawingTimer();
                },
                onPointerUp: (PointerUpEvent event) {
                  setState(() {
                    isDrawing = false;
                  });
                  _stopDrawingTimer();
                  drawingCounter++;
                },
                child: Column(
                  children: [
                    // Display the selected test image
                    Image.asset(
                      widget.testImagePath,
                      height: 100, // Adjust the height as needed
                    ),
                    // Signature pad
                    Signature(
                      controller: _controller,
                     
                      height: 300, // Adjust the height as needed
                      backgroundColor: Colors.white,
                
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _saveSignature();
                  },
                  child: const Text('enregistrer'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _resetSignature();
                  },
                  child: const Text('reinitialiser'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _compareWithReferenceImage();
                  },
                  child: const Text('Comparer'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDrawing ? Colors.green : Colors.red,
                  ),
                  child: Text(
                    isDrawing ? '1' : '0',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
 void _onPointSigned() {
    if (isDrawing) {
      drawingTimer?.cancel(); // Cancel previous timer
      drawingTimer = Timer.periodic(Duration(milliseconds: 1), (timer) {
        drawingsData.last.add({
          'x': _controller.points.last.offset.dx,
          'y': _controller.points.last.offset.dy,
        });
      });
    }
  }
   void _startDrawingTimer() {
    drawingsData.add([]); // Start a new drawing
    drawingTimer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      drawingsData.last.add({
        'x': _controller.points.last.offset.dx,
        'y': _controller.points.last.offset.dy,
        'n' : drawingCounter ,
      });
    });
  }
void _stopDrawingTimer() {
    drawingTimer?.cancel();
  }
  void _saveSignature() async {
    try {
  
      _stopDrawingTimer();
   
      // Convert the drawn signature to an image
      final Uint8List? signatureData = await _controller.toPngBytes();

      if (signatureData == null) {
        return;
      }
   List<Map<String, dynamic>> flattenedDrawingsData =
        drawingsData.expand((list) => list).toList();
      // Convert Uint8List to base64 string
      final String base64Signature = base64Encode(signatureData);
  // Save the signature data along with the coordinates
    await FirebaseFirestore.instance.collection('signatures').add({
      'signature_data': base64Signature,
      'drawings_data': flattenedDrawingsData,
      'drawing_counter': drawingCounter,
      'timestamp': FieldValue.serverTimestamp(),
      'test_name': widget.testName,
    });

     
      // await FirebaseFirestore.instance.collection('signatures').add({
      //   'signature_data': base64Signature,
      //   'timestamp': FieldValue.serverTimestamp(),
      //   'test_name': widget.testName,
      // });

      print('Signature saved successfully');
    } catch (e) {
      print('Error of saving signature: $e');
    }
  }

  void _resetSignature() {
    _controller.clear();
  }

  Future<void> _compareWithReferenceImage() async {
    // Convert the drawn signature to an image
    final Uint8List? signatureData = await _controller.toPngBytes();
    if (signatureData == null) {
      return;
    }

    final img.Image drawnSignatureImage =
        img.decodeImage(Uint8List.fromList(signatureData))!;

    // Load the reference image (replace 'reference_image.png' with your reference image)
    final Uint8List referenceImageData =
        (await rootBundle.load('assets/images/eclipse.png'))
            .buffer
            .asUint8List();
    final img.Image referenceImage =
        img.decodeImage(Uint8List.fromList(referenceImageData))!;

    // Calculate Mean Squared Error (MSE)
    final double mse = _calculateMSE(drawnSignatureImage, referenceImage);

    // Display the MSE
    // ignore: avoid_print
    print('Mean Squared Error: $mse');
  }

  double _calculateMSE(img.Image image1, img.Image image2) {
    double mse = 0.0;

    for (int y = 0; y < image1.height; y++) {
      for (int x = 0; x < image1.width; x++) {
        final int pixel1 = image1.getPixel(x, y) as int;
        final int pixel2 = image2.getPixel(x, y) as int;

        final int delta = pixel1 - pixel2;
        mse += delta * delta;
      }
    }

    mse /= (image1.width * image1.height);
    return mse;
  }
}
