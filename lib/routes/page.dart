import 'package:get/get.dart';
import '../home/page/home_layout.dart';
import 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeLayout(),
    ),
  ];
}
