import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/CustomButton.dart';
import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/screens/Authentication/SignInPage.dart';
import 'package:attendance_system_nodejs/screens/Home/HomePage.dart';
import 'package:attendance_system_nodejs/services/API.dart';
import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image1;
  File? _image2;
  File? _image3;
  List<XFile> images = [];
  SecureStorage secureStorage = SecureStorage();
  late ProgressDialog _progressDialog;

  Future<void> _getImageFromCamera(int imageIndex) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        switch (imageIndex) {
          case 1:
            _image1 = File(image.path);
            secureStorage.writeSecureData('_image1', _image1!.path);
            break;
          case 2:
            _image2 = File(image.path);
            secureStorage.writeSecureData('_image2', _image2!.path);

            break;
          case 3:
            _image3 = File(image.path);
            secureStorage.writeSecureData('_image3', _image3!.path);
            break;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progressDialog = ProgressDialog(context,
        customBody: Container(
          width: 200,
          height: 150,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primaryButton,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Loading',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const SignInPage()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back_ios,
                size: 25, color: Colors.white)),
        centerTitle: true,
        title: const Text(
          'Upload Face',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryButton,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _getImageFromCamera(1),
                  child: _image1 != null
                      ? Image.file(
                          _image1!,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.3,
                        )
                      : selectImage(context),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _getImageFromCamera(2),
                  child: _image2 != null
                      ? Image.file(
                          _image2!,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.3,
                        )
                      : selectImage(context),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _getImageFromCamera(3),
                  child: _image3 != null
                      ? Image.file(
                          _image3!,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.3,
                        )
                      : selectImage(context),
                ),
                const SizedBox(height: 5),
                if (_image1 != null && _image2 != null && _image3 != null)
                  InkWell(
                    onTap: () async {
                      var _image1 =
                          await secureStorage.readSecureData('_image1');
                      images.add(XFile(_image1));
                      var _image2 =
                          await secureStorage.readSecureData('_image2');
                      images.add(XFile(_image2));
                      var _image3 =
                          await secureStorage.readSecureData('_image3');
                      images.add(XFile(_image3));
                      String studentID =
                          await secureStorage.readSecureData('studentID');
                      _progressDialog.show();
                      bool check = await API(context)
                          .uploadMultipleImage(studentID, images);
                      if (check) {
                        await _progressDialog.hide();
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Upload Sucessfully'),
                            content: const Text(
                                'You can check image face in settings'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => HomePage()),
                                      (route) => false); // Đóng hộp thoại
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        await _progressDialog.hide();
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Failed Upload'),
                            content: const Text('Please check required'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context); // Đóng hộp thoại
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryButton,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: const Center(
                        child: CustomText(
                          message: 'Upload Image',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryButton,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: const Center(
                      child: CustomText(
                        message: 'Required 3 image Face',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container selectImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          style: BorderStyle.solid,
          color: AppColors.primaryButton.withOpacity(0.5),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.plus_one_outlined,
              size: 40,
              color: AppColors.primaryButton,
            ),
            CustomText(
              message: 'Add your face',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryButton,
            ),
          ],
        ),
      ),
    );
  }
}
