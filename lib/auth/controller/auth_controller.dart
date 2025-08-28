import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  bool skipInitialScreen = false; // evita navegación automática

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _handleAuthState);
  }

  // Este método se asegura de solo navegar si no estamos en un proceso especial
  void _handleAuthState(User? user) {
    if (!skipInitialScreen) {
      _setInitialScreen(user);
    }
  }

  // Lógica que decide si enviar al login, home o perfil
  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      final dbRef = FirebaseDatabase.instance.ref().child('usuarios/${user.uid}');
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/perfil');
      }
    }
  }

  // Registrar usuario y evitar navegación automática
  Future<void> register(String email, String password) async {
    try {
      skipInitialScreen = true;

      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await logout();

      skipInitialScreen = false;

      Get.snackbar('Éxito', 'Usuario registrado correctamente');
      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      skipInitialScreen = false;
      String errorMessage = 'Ocurrió un error al registrar';

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'El correo ya está registrado';
          break;
        case 'invalid-email':
          errorMessage = 'El correo electrónico no es válido';
          break;
        case 'weak-password':
          errorMessage = 'La contraseña es demasiado débil';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      Get.snackbar('Error', errorMessage);
    } catch (e) {
      skipInitialScreen = false;
      Get.snackbar('Error', 'Error desconocido: ${e.toString()}');
    }
  }


  // Iniciar sesión
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _setInitialScreen(_auth.currentUser);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
  }
}
