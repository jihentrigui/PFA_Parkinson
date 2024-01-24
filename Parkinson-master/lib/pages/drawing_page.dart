import 'dart:convert';

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
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveSignature() async {
    try {
      // Convert the drawn signature to an image
      final Uint8List? signatureData = await _controller.toPngBytes();

      if (signatureData == null) {
        return;
      }

      // Convert Uint8List to base64 string
      final String base64Signature = base64Encode(signatureData);

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
