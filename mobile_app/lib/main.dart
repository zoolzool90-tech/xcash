import 'package:flutter/material.dart';
import 'constants/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const XCashApp());
}

class XCashApp extends StatelessWidget {
  const XCashApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X Cash',
      debugShowCheckedModeBanner: false,
      theme: XCashTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
