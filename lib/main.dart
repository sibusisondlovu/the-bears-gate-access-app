import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gate_access/config/app_colors.dart';
import 'package:gate_access/config/routes.dart';
import 'package:gate_access/features/scan_menu_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => AuthenticationController()),
      ],
      child: MaterialApp(
        title: 'Gate Access',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Ubuntu', primaryColor: AppColors.darkMainColor),
        initialRoute: ScanMenuScreen.id,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ));
  });
}