import 'package:get/get.dart';
import '../auth/pages/login_page.dart';
import '../auth/pages/register_page.dart';
import '../home/page/home_layout.dart';
import '../veterinaria/page/cita_page.dart';
import '../veterinaria/page/mascotacontroller_form_page.dart';
import '../veterinaria/page/perfil_form_page.dart';
import 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.register, page: () => RegisterPage()),
    GetPage(name: AppRoutes.perfil, page: () => PerfilFormPage()),
    GetPage(name: AppRoutes.mascotas, page: () => MascotaScreenUnica()),
    GetPage(name: AppRoutes.citas, page: () => CitaPage()),
    GetPage(name: AppRoutes.home, page: () => HomeLayout()),


  ];
}

