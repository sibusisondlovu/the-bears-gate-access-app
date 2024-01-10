
import 'package:flutter/material.dart';
import 'package:gate_access/features/scaning/car_disk_scan_screen.dart';
import 'package:gate_access/features/scaning/scan_menu_screen.dart';
import 'package:gate_access/features/scaning/scan_types_menu.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as dynamic;
    switch (settings.name) {

      case ScanMenuScreen.id:
        return _route(const ScanMenuScreen());

      case ScanTypesMenuScreen.id:
        return _route(ScanTypesMenuScreen(entryId: args,));

      case CarDiskScanScreen.id:
        return _route(const CarDiskScanScreen());

      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _route(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

  static Route<dynamic> _errorRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Route not found'),
        ),
        body: Center(
          child: Text(
            'ROUTE \n\n$name\n\nNOT FOUND',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
