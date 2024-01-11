import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();
  final String newUuid = uuid.v4();

  Future<DocumentSnapshot?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('employees').doc(uid).get();
        return snapshot;
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching document: $e');
        }
        return null;
      }
    } else {
      return null;
    }
  }

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
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, 'loginScreen');
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ))
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder(
                future: getUserData(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data found'));
                  } else {
                    Map<String, dynamic> userData =
                        snapshot.data!.data() as Map<String, dynamic>;

                    String employeeCode = userData['empCode'];
                    String employeeName =
                        userData['name'] + ' ' + userData['surname'];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                        ),
                        const Text('Logged in as:'),
                        Text(userData['name'] + ' ' + userData['surname'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28)),
                        Text(userData['empCode'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: ListTile(
                            onTap: () async {
                              // await createEntry(employeeCode, employeeName);
                              Navigator.pushNamed(context, 'scanTypesMenuScreen', arguments: newUuid);
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
                              style:
                                  TextStyle(fontSize: 32, color: Colors.white),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
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
                              style:
                                  TextStyle(fontSize: 32, color: Colors.white),
                            ),
                            trailing: Icon(Icons.cancel),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ],
                    );
                  }
                },
              ));
  }
}
