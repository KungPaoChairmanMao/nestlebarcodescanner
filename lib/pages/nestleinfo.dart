import 'package:flutter/material.dart';

class NestleInfo extends StatelessWidget {
  const NestleInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.lightGreen,
        Colors.red.shade400,
      ])),
    );
  }
}
