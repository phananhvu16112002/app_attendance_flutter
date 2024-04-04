import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: GifView.asset('assets/gifs/success.gif'),
      ),
    );
  }
}