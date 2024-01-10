import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gate_access/config/app_colors.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanTypesMenuScreen extends StatefulWidget {
  const ScanTypesMenuScreen({super.key, required this.entryId});
  static const String id = 'scanTypesMenuScreen';
  final String entryId;

  @override
  State<ScanTypesMenuScreen> createState() => _ScanTypesMenuScreenState();
}

class _ScanTypesMenuScreenState extends State<ScanTypesMenuScreen> {
  String carDiskInformation = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();

  Future _scanDriverLicence(final imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    String text = recognizedText.text.toString();

    try {
      await _firestore.collection('vehicleEntries').doc(widget.entryId).update({
        'diskInformation': text,
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

  Future _scanCarDisk(final imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    String text = recognizedText.text.toString();

    try {
      await _firestore.collection('vehicleEntries').doc(widget.entryId).update({
        'diskInformation': text,
      });



      if (kDebugMode) {
        print('Text saved to Firestore!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving text: $e');
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 150),
            height: 75,
            width: MediaQuery.of(context).size.width * 0.8, // Set width to 80% of the screen width
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await _firestore.collection('yourCollection').doc(widget.entryId).delete();
                  print('Document deleted successfully');
                  Navigator.pop(context);
                } catch (e) {
                  print('Error deleting document: $e');
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Set the background color to black
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0), // Set rounded corners
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
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('vehicleEntries').doc(widget.entryId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return const Center(child: Text('An Error Occurred'));
              } else if (!snapshot.data!.exists) {
                return const Center(child: Text('Document does not exist'));
              } else {

                Map<String, dynamic> documentData = snapshot.data!.data() as Map<String, dynamic>;
                String diskInformation = documentData['diskInformation'] ?? '';
                String driveInformation = documentData['driverLicence'] ?? '';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: ListTile(
                        onTap: () async {
                          carDiskScan();
                        },
                        iconColor: Colors.white,
                        minVerticalPadding: 30,
                        tileColor: AppColors.darkMainColor,
                        leading: Image.asset(
                          'assets/images/car-disk.png',
                          width: 50,
                        ),
                        title: const Text(
                          'CAR DISK',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        trailing: diskInformation == '' ? const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ) : const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: ListTile(
                        onTap: () {
                          driverLicenceScan();
                        },
                        iconColor: Colors.white,
                        minVerticalPadding: 30,
                        tileColor: AppColors.darkMainColor,
                        leading: Image.asset(
                          'assets/images/driver-licence.jpg',
                          width: 50,
                        ),
                        title: const Text(
                          'DRIVER LICENCE',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        trailing: driveInformation == '' ? const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ) : const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    diskInformation.isNotEmpty && driveInformation.isNotEmpty? SizedBox(
                      height: 75,
                      width: MediaQuery.of(context).size.width * 0.8, // Set width to 80% of the screen width
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your onPressed logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Set the background color to black
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0), // Set rounded corners
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
                    ):Container(),
                    const Text(
                      'Entry ID',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.entryId,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }


  Future<void> carDiskScan() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    String a = await _scanCarDisk(image!.path);
    setState(() {
      carDiskInformation = a;
    });
  }

  Future<void> driverLicenceScan() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    String a = await _scanDriverLicence(image!.path);
    setState(() {
      carDiskInformation = a;
    });
  }

}
