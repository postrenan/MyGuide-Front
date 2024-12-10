import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myguide_app/src/features/authentication/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega as variáveis de ambiente
  await dotenv.load(fileName: ".env");

  // Inicializa o app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: SafeArea(
          child: LoginPage(),
        ),
      ),
    );
  }
}
