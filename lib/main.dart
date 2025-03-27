import 'package:flutter/material.dart';
import 'package:mtr_puzzle/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pindot Puzzler Game',
      color: Colors.grey.shade900,
      darkTheme: ThemeData(
        fontFamily: 'Manrope',
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const PuzzleGame(),
    );
  }
}
