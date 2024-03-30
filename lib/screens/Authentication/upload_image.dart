import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/home_page.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
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
            // images.add(XFile(_image1!.path));
            print('add data');
            secureStorage.writeSecureData('_image1', _image1!.path);
            break;
          case 2:
            _image2 = File(image.path);
            // images.add(XFile(_image2!.path));

            secureStorage.writeSecureData('_image2', _image2!.path);

            break;
          case 3:
            _image3 = File(image.path);
            // images.add(XFile(_image3!.path));
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
    _progressDialog = customDialogLoading();
  }

  ProgressDialog customDialogLoading() {
    return ProgressDialog(context,
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
              images.clear();
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
                      var image1 =
                          await secureStorage.readSecureData('_image1');
                      images.add(XFile(image1));
                      var image2 =
                          await secureStorage.readSecureData('_image2');
                      images.add(XFile(image2));
                      var image3 =
                          await secureStorage.readSecureData('_image3');
                      images.add(XFile(image3));
                      // print(images.length);
                      // for (int i = 0; i < images.length; i++) {
                      //   print(images[i]);
                      // }
                      String studentID =
                          await secureStorage.readSecureData('studentID');
                      _progressDialog.show();
                      bool check = await API(context)
                          .uploadMultipleImage(studentID, images);
                      if (check) {
                        await _progressDialog.hide();
                        await dialogSuccess(context);
                        // images.clear();
                      } else {
                        await _progressDialog.hide();
                        await dialogFailed(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryButton,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: const Center(
                          child: CustomText(
                            message: 'Upload Image',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                        fontSize: 18,
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

  Future<dynamic> dialogFailed(BuildContext context) {
    return showDialog(
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

  Future<dynamic> dialogSuccess(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Sucessfully'),
        content: const Text('You can check image face in settings'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => HomePage()),
                  (route) => false); // Đóng hộp thoại
            },
            child: const Text('OK'),
          ),
        ],
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

//  Container carousel() {
//     return Container(
//       width: double.infinity,
//       color: Colors.white,
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 8,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Hot Camp',
//                     style: TextStyle(
//                         color: AppColors.primary3,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700)),
//                 Row(
//                   children: [
//                     const Text('See more',
//                         style: TextStyle(
//                             color: AppColors.primary3,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400)),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     SvgPicture.asset('assets/icons/more.svg')
//                   ],
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           CarouselSlider(
//             carouselController: carouselController,
//             options: CarouselOptions(
//               aspectRatio: 14.2 / 10.3,
//               viewportFraction: 0.55,
//               initialPage: 0,
//               enableInfiniteScroll: true,
//               reverse: false,
//               // autoPlay: true,
//               autoPlayInterval: const Duration(seconds: 3),
//               autoPlayAnimationDuration: const Duration(milliseconds: 800),
//               autoPlayCurve: Curves.fastOutSlowIn,
//               enlargeCenterPage: true,
//               scrollDirection: Axis.horizontal,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   currentIndex = index;
//                 });
//               },
//             ),
//             items: imageUrls.map((e) {
//               return Builder(
//                 builder: (BuildContext context) {
//                   return currentIndex == imageUrls.indexOf(e)
//                       ? Container(
//                           decoration: const BoxDecoration(
//                             color: AppColors.primary3,
//                             borderRadius: BorderRadius.all(Radius.circular(16)),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(8),
//                                       topRight: Radius.circular(8),
//                                       bottomLeft: Radius.circular(8)),
//                                   child: Image.asset(
//                                     e,
//                                     width: 230,
//                                     height: 200,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 const Text(
//                                   'Himalayaa mountain peak',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: AppColors.colorText,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Row(
//                                   children: [
//                                     SvgPicture.asset(
//                                         'assets/icons/location.svg'),
//                                     const SizedBox(width: 2),
//                                     const Text(
//                                       'Himalayan',
//                                       style: TextStyle(
//                                           fontSize: 10,
//                                           color: AppColors.colorText,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Row(
//                                   children: [
//                                     SvgPicture.asset('assets/icons/star.svg'),
//                                     const SizedBox(width: 2),
//                                     const Text(
//                                       '4.5  ',
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           color: AppColors.colorText,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Stack(
//                           children: [
//                             Container(
//                               width: 180,
//                               height: 250,
//                               decoration: const BoxDecoration(
//                                 color: AppColors.primary3,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(8)),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       width: 180,
//                                       height: 150,
//                                       child: Image.asset(
//                                         e,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 16),
//                                     const Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 16.0),
//                                       child: Text(
//                                         'Himalayaa mountain peak',
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: AppColors.colorText,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16.0),
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                               'assets/icons/location.svg'),
//                                           const SizedBox(width: 2),
//                                           const Text(
//                                             'Himalayan',
//                                             style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: AppColors.colorText,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               height: 250,
//                               width: 180,
//                               color: Colors.white.withOpacity(0.5),
//                             )
//                           ],
//                         );
//                 },
//               );
//             }).toList(),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//         ],
//       ),
//     );
//   }
