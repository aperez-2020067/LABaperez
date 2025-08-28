import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namer_app/routes/page.dart';
import 'data/veterinaria/controllers/veterinario_controller.dart';
import 'routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(AuthController());

  await crearVeterinariosPorDefecto();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mi App',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.login,
    );
  }
}
