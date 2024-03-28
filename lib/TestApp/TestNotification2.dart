import 'package:flutter/material.dart';

class TestNotification2 extends StatefulWidget {
  const TestNotification2({super.key, required this.payload});
  final String payload;

  @override
  State<TestNotification2> createState() => _TestNotification2State();
}

class _TestNotification2State extends State<TestNotification2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('${widget.payload}'),
      ),
    );
  }
}
