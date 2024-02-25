import 'dart:async';
import 'dart:convert';
import 'dart:math';
//import 'dart:math';
//import 'dart:ffi';

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
  List<List<Map<String, dynamic>>> timedrawingsData = [];

  bool isDrawing = false;
  Timer? drawingTimer;
   int drawingCounter = 0;
DateTime? startTime;
     
  //List<double> tabx = [];
//List<double> taby = [];
//List<int> tabn = [];

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
    startTime = DateTime.now(); // Store start time of drawing
  timedrawingsData.add([]);

    drawingTimer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      drawingsData.last.add({
        'x': _controller.points.last.offset.dx,
        'y': _controller.points.last.offset.dy,
        'n' : drawingCounter ,
      });
     // tabx.add(_controller.points.last.offset.dx);
      //taby.add(_controller.points.last.offset.dy);
      //tabn.add(drawingCounter);
    });
  }
void _stopDrawingTimer() {

if (timedrawingsData.isNotEmpty) {
    timedrawingsData.last.add({
      'n' : drawingCounter,
      'time': DateTime.now().difference(startTime!).inMilliseconds, // Calculate time difference
    });
}
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

     List<Map<String, dynamic>> flattenedtimeDrawingsData =
        timedrawingsData.expand((list) => list).toList();    
      // Convert Uint8List to base64 string
      final String base64Signature = base64Encode(signatureData);
  // Save the signature data along with the coordinates
    await FirebaseFirestore.instance.collection('signatures').add({
      'signature_data': base64Signature,
      'drawings_data': flattenedDrawingsData,
      //'X' : tabx,
      //'Y' : taby,
      //'n' : tabn,
      'drawing_counter': drawingCounter,
      'drawing_time':flattenedtimeDrawingsData,
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
bool isVector(List<dynamic> list) {
  // Vérifie si la liste est unidimensionnelle
  for (var element in list) {
    if (element is List) {
      return false;
    }
  }
  return true;
}
double standardDeviation(List<double> signal) {
  double mean = signal.reduce((a, b) => a + b) / signal.length;
  double variance = signal.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) / signal.length;
  return sqrt(variance);
}
List<double> calculateDistances(List<List<double>> matches, String distType) {
  List<double> distances = [];
  for (int i = 0; i < matches.length; i++) {
    for (int j = i + 1; j < matches.length; j++) {
      double distance = calculateDistance(matches[i], matches[j], distType);
      distances.add(distance);
    }
  }
  return distances;
}
double calculateDistance(List<double> a, List<double> b, String distType) {
  if (distType == 'chebyshev') {
    return chebyshevDistance(a, b);
  } else {
    throw ArgumentError('Unsupported distance type: $distType');
  }
}
double chebyshevDistance(List<double> a, List<double> b) {
  double maxDiff = 0.0;
  for (int i = 0; i < a.length; i++) {
    double diff = (a[i] - b[i]).abs();
    if (diff > maxDiff) {
      maxDiff = diff;
    }
  }
  return maxDiff;
}
int countMatches(List<double> distances, double r, double sigma) {
  int count = 0;
  for (double distance in distances) {
    if (distance <= r * sigma) {
      count++;
    }
  }
  return count;
}

double sampen(List<double> signal, int m, double r,{String distType = 'chebyshev'}) {
     double value ;
   // Error detection and defaults
  if (m == null || r == null) {
    throw ArgumentError('Not enough parameters.');
  }
  if (distType == null) {
    distType = 'chebyshev';
    print('[WARNING] Using default distance method: chebyshev.');
  }
  if (signal.isEmpty || !isVector(signal)) {
    throw ArgumentError('The signal parameter must be a vector.');
  }
  if (distType == null || distType is! String) {
    throw ArgumentError('Distance must be a string.');
  }
  if (m >= signal.length) {
    throw ArgumentError('Embedding dimension must be smaller than the signal length (m < N).');
  }

  //Useful parameters
  int N = signal.length; // Signal length
  double sigma = standardDeviation(signal); // Standard deviation

  //Create the matrix of matches
  List<List<double>> matches = List.generate(m + 1, (_) => List<double>.filled(signal.length - m + 1, double.nan));
  
  for (int i = 0; i < m + 1; i++) {
    for (int j = 0; j < signal.length + 1 - i; j++) {
      matches[i][j] = signal[j + i];
    }
  }

  //Check the matches for m
  List<double> d_m = calculateDistances(matches.sublist(0, m), distType);
 if (d_m.isEmpty) {
    // If B = 0, SampEn is not defined: no regularity detected
    // Note: Upper bound is returned
    value = double.infinity;
 } else {
    // Check the matches for m+1
    List<double> d_m1 = calculateDistances(matches.sublist(0, m + 1), distType);
    // Compute A and B
    //Note: logical operations over NaN values are always 0
    int B = countMatches(d_m, r, sigma);
    int A = countMatches(d_m1, r, sigma);
    // Sample entropy value
    //Note: norm. comes from [nchoosek(N-m+1,2)/nchoosek(N-m,2)]
     value = -log((A / B) * ((N - m + 1) / (N - m - 1)));
  }
    //If A=0 or B=0, SampEn would return an infinite value. However, the
    // lowest non-zero conditional probability that SampEn should
    // report is A/B = 2/[(N-m-1)(N-m)]
    if (value.isInfinite) {
    value = -log(2 / ((N - m - 1) * (N - m)));
  }

  return value;




}
