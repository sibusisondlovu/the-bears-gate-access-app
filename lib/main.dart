import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gate_access/config/app_colors.dart';
import 'package:gate_access/config/routes.dart';
import 'package:gate_access/features/scan_menu_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBHPpeIKziMz4HkMT9OpevYpSruFqps1uw',
      appId: '1:206325093013:android:1a5efaed74b44cdb05819c',
      messagingSenderId: '206325093013',
      projectId: 'the-bears',
      storageBucket: 'the-bears.appspot.com',
    )
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      title: 'Gate Access',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Ubuntu', primaryColor: AppColors.darkMainColor),
      initialRoute: ScanMenuScreen.id,
      onGenerateRoute: RouteGenerator.generateRoute,
    ));
  });
}