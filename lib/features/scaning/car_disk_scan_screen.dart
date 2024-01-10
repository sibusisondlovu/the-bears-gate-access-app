import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class CarDiskScanScreen extends StatefulWidget {
  const CarDiskScanScreen({super.key});
  static const String id = 'carDiskScanScreen';

  @override
  State<CarDiskScanScreen> createState() => _CarDiskScanScreenState();
}

class _CarDiskScanScreenState extends State<CarDiskScanScreen> {

  String scannedText = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();

  Future _scanCarDisk(final imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    String text = recognizedText.text.toString();
    return text;
  }

  Future<void> _saveToFirestore(String text) async {
    try {
      await _firestore.collection('car_disk_texts').add({
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Text saved to Firestore!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving text: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Car Disk'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                String a = await _scanCarDisk(image!.path);
                setState(() {
                  scannedText = a;
                });
              },
              child: Text('Scan Car Disk'),
            ),
            SizedBox(height: 20),
            Text(
              'Scanned Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(scannedText),
          ],
        ),
      ),
    );
  }
}
