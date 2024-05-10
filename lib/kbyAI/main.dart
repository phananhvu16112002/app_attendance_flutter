// ignore_for_file: depend_on_referenced_packages

import 'package:attendance_system_nodejs/kbyAI/home_face.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'about.dart';
import 'settings.dart';
import 'person.dart';
import 'personview.dart';
import 'facedetectionview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Face Recognition',
        theme: ThemeData(
          // Define the default brightness and colors.
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: MyHomePage(title: 'Face Recognition'));
  }
}

// ignore: must_be_immutable

