import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gate_access/config/app_colors.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ScanTypesMenuScreen extends StatefulWidget {
  const ScanTypesMenuScreen({super.key, required this.entryId});
  static const String id = 'scanTypesMenuScreen';
  final String entryId;

  @override
  State<ScanTypesMenuScreen> createState() => _ScanTypesMenuScreenState();
}

class _ScanTypesMenuScreenState extends State<ScanTypesMenuScreen> {
  String carDiskInformation = '';
  String licenceInformation = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  String? driverDiskImagePath;
  String? licenceDiskImagePath;

  void _scanDriverLicence(final imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath));

    setState(() {
      licenceInformation = recognizedText.text.toString();
    });
  }

  void _scanCarDisk(final imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath));

    setState(() {
      carDiskInformation = recognizedText.text.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
            height: 75,
            width: MediaQuery.of(context).size.width *
                0.8, // Set width to 80% of the screen width
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent, // Set the background color to black
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(25.0), // Set rounded corners
                ),
              ),
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white, // Set text color to white
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              licenceDiskImagePath == null? ClipOval(
                child: Image.asset(
                  'assets/images/car-disk.png',
                  width: 200, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
              ): ClipOval(
                child: Image.file(
                  File(licenceDiskImagePath!),
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    carDiskScan();
                  },
                  child: const Text(
                    'SCAN LICENCE DISK',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 2),
                  )),
              const Divider(height: 1),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              driverDiskImagePath == null? Image.asset(
                'assets/images/driver-licence.jpg',
                width: 270,
                height: 150,
                fit: BoxFit.fill,
              ): Image.file(
                File(driverDiskImagePath!),
                width: 270,
                height: 150,
                fit: BoxFit.fill,
              ),
              ElevatedButton(
                  onPressed: () {
                    driverLicenceScan();
                  },
                  child: const Text(
                    'SCAN DRIVER LICENCE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 2),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              carDiskInformation.isNotEmpty && licenceInformation.isNotEmpty
                  ? SizedBox(
                      height: 75,
                      width: MediaQuery.of(context).size.width *
                          0.8, // Set width to 80% of the screen width
                      child: ElevatedButton(
                        onPressed: () async {
                         await createEntry();
                         Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green, // Set the background color to black
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Set rounded corners
                          ),
                        ),
                        child: const Text(
                          'PROCEED',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white, // Set text color to white
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              const Text(
                'Entry ID',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.entryId,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> carDiskScan() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      licenceDiskImagePath = image!.path;
    });
    _scanCarDisk(image!.path);
  }

  Future<void> driverLicenceScan() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      driverDiskImagePath = image!.path;
    });
    _scanDriverLicence(image!.path);
  }

  Future<void> createEntry() async {
    var now = DateTime.now();
    var entryTime = DateFormat("dd MMMM yyyy 'at' HH'h'mm")
        .format(now)
        .replaceAll('at', '@');

    final newEntryMap = {
      'entryId': widget.entryId,
      'dateTimeIn': entryTime,
      'dateTimeOut': '',
      'diskInformation': carDiskInformation,
      'driverLicence': licenceInformation,
      'employeeCode': FirebaseAuth.instance.currentUser!.uid,
    };
    try {
      await _firestore
          .collection('vehicleEntries')
          .doc(widget.entryId)
          .set(newEntryMap);
      if (kDebugMode) {
        print('done');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating entry: $e');
      }
    }

  }
}
