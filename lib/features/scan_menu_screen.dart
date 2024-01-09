import 'package:flutter/material.dart';
import 'package:gate_access/config/app_colors.dart';

class ScanMenuScreen extends StatefulWidget {
  const ScanMenuScreen({super.key});
  static const String id = 'scanMenuScreen';

  @override
  State<ScanMenuScreen> createState() => _ScanMenuScreenState();
}

class _ScanMenuScreenState extends State<ScanMenuScreen> {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          Text('Logged in as:'),
          Text('NAME SURNAME',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              iconColor: Colors.white,
              minVerticalPadding: 30,
              tileColor: AppColors.darkMainColor,
              leading: Icon(
                Icons.arrow_downward,
                size: 80,
              ),
              title: Text(
                'SCAN IN',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              trailing: Icon(Icons.cancel),
            ),
          ),
          Padding(
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
          Text('10 January 2024'),
          Text('23:45.34', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28
          )
          ),
        ],
      ),
    );
  }
}
