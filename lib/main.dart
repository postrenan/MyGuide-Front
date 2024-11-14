import 'package:flutter/material.dart';
import 'package:myguide_app/src/features/authentication/login_page.dart';
/*import 'package:myguide_app/src/features/authentication/screens/register_page.dart';*/
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: LoginPage(),
        ),
      ),
    );
  }
}

/*class MyApp extends StatelessWidget { // Altere aqui para testar a tela de registro
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: RegisterPage(), 
        ),
      ),
    );
  }
}*/