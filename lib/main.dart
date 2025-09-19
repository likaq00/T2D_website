import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    // authFlowType removed for supabase_flutter ^2.10.x
  );

  runApp(const T2DApp());
}

class T2DApp extends StatelessWidget {
  const T2DApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );

    return MaterialApp.router(
      title: 'T2D Digital Twin',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      routerConfig: buildRouter(),
    );
  }
}
