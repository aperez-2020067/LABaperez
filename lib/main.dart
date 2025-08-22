import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namer_app/routes/page.dart';
import 'routes/routes.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.home,
    );
  }
}

