import 'package:flutter/material.dart';
import 'navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nestle Barcode Scanner',
      theme: ThemeData(
        primaryColor: Colors.blue[500],
      ),
      home: Nav(),
    );
  }
}
