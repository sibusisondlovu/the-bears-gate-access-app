import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gate_access/config/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ScanMenuScreen extends StatefulWidget {
  const ScanMenuScreen({super.key});
  static const String id = 'scanMenuScreen';

  @override
  State<ScanMenuScreen> createState() => _ScanMenuScreenState();
}

class _ScanMenuScreenState extends State<ScanMenuScreen> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        toolbarHeight: 90,
        centerTitle: true,
        title: const Text(
          'Gate Access',
          style: TextStyle(color: Colors.white),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/app-logo.png',
            width: 50,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body:isLoading? const Center(child: CircularProgressIndicator(),) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          const Text('Logged in as:'),
          const Text('NAME SURNAME',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              onTap: ()async{
                await createEntry(context);
              },
              iconColor: Colors.white,
              minVerticalPadding: 30,
              tileColor: AppColors.darkMainColor,
              leading: const Icon(
                Icons.arrow_downward,
                size: 80,
              ),
              title: const Text(
                'SCAN IN',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              iconColor: Colors.white,
              minVerticalPadding: 30,
              tileColor: AppColors.darkMainColor,
              leading: Icon(
                Icons.arrow_upward,
                size: 80,
              ),
              title: Text(
                'SCAN OUT',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              trailing: Icon(Icons.cancel),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          const Text('10 January 2024'),
          const Text('23:45.34', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28
          )
          ),
        ],
      ),
    );
  }

  Future<void> createEntry(context) async {
    setState(() {
      isLoading = true;
    });

    var uuid = const Uuid();
    var now = DateTime.now();
    var entryTime = DateFormat("dd MMMM yyyy 'at' HH'h'mm")
        .format(now)
        .replaceAll('at', '@');
    final String newUuid = uuid.v4();
    final newEntryMap = {
      'entryId': newUuid,
      'dateTimeIn': entryTime,
      'dateTimeOut': '',
      'diskInformation' : '',
      'driverPhoto': '',
      'vehiclePhoto': '',
      'driverLicence': '',
      'staffId' : 'EMP0001',
    };
    try {
      await FirebaseFirestore.instance
          .collection('vehicleEntries')
          .doc(newUuid)
          .set(newEntryMap);

      setState(() {
        isLoading = false;
      });

      // Navigate to the new page with the entryId
      Navigator.pushNamed(context, 'scanTypesMenuScreen', arguments: newUuid);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating entry: $e');
      }
      setState(() {
        isLoading = false;
      });

    }
  }
}
