import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TestQRCode extends StatefulWidget {
  const TestQRCode({super.key});

  @override
  State<TestQRCode> createState() => _TestQRCodeState();
}

class _TestQRCodeState extends State<TestQRCode> {
  String? data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test QRCODE'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter your data'),
              onChanged: (value) {
                setState(() {
                  data = value;
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            data != null
                ? QrImageView(
                    version: 10,
                    data: data.toString(),
                    size: 200,
                    padding: EdgeInsets.all(0),
                    embeddedImage: AssetImage('assets/images/logo.png'),
                    eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square, color: Colors.black),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
