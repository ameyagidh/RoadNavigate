import 'package:flutter/material.dart';
import 'package:roadnavigate/views/camera_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detection Assistant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 109, 43, 222)),
        useMaterial3: true,
      ),
      home: const CameraView(),
    );
  }
}
