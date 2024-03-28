import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/CustomButton.dart';
import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class FloatingButtonReport extends StatefulWidget {
  const FloatingButtonReport({super.key});

  @override
  State<FloatingButtonReport> createState() => _FloatingButtonReportState();
}

class _FloatingButtonReportState extends State<FloatingButtonReport> {
  final TextEditingController _lectuerController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _message = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  // Initial Selected Value

  // List of items in our dropdown menu
  var items = [
    'Device failure',
    'Personal reason',
    'Others',
  ];
  String dropdownvalue = 'Device failure';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: AppColors.colorAppbar,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                      message: 'Cross-Platform Programming',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  Row(
                    children: [
                      const CustomText(
                          message: 'CourseID: 502012',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(height: 10, width: 1, color: Colors.white),
                      const SizedBox(
                        width: 10,
                      ),
                      const CustomText(
                          message: 'Room: A0503',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(height: 10, width: 1, color: Colors.white),
                      const SizedBox(
                        width: 10,
                      ),
                      const CustomText(
                          message: 'Shift: 5',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const CustomText(
                      message: 'Lectuer: Mai Van Manh',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Container(
            width: 400,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.secondaryText,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.0))
                ]),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Text(
                    'Send Report To Lectuer',
                    style: GoogleFonts.inter(
                        color: AppColors.primaryButton,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                                message: 'Send To:',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText),
                            const SizedBox(
                              height: 5,
                            ),
                            customFormField(
                                'Mai Van Manh',
                                370,
                                50,
                                _lectuerController,
                                IconButton(
                                    onPressed: () {}, icon: const Icon(null)),
                                1,
                                true),
                            const SizedBox(
                              height: 10,
                            ),
                            const CustomText(
                                message: 'Topic',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText),
                            const SizedBox(
                              height: 5,
                            ),
                            customFormField(
                                'Attendance Form 7 January, 2023',
                                370,
                                50,
                                _topicController,
                                IconButton(
                                    onPressed: () {}, icon: const Icon(null)),
                                1,
                                false),
                            const SizedBox(
                              height: 10,
                            ),
                            const CustomText(
                                message: 'Type Of Problem',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 370,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    width: 1,
                                    color: const Color.fromARGB(
                                        92, 190, 188, 188)),
                              ),
                              child: DropdownButton(
                                underline: Container(),
                                value: dropdownvalue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                      value: items,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          width: 317,
                                          child: Text(
                                            items,
                                            style: const TextStyle(
                                                color:
                                                    Color.fromARGB(99, 0, 0, 0),
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const CustomText(
                                message: 'Message',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText),
                            const SizedBox(
                              height: 5,
                            ),
                            customFormField(
                              'Description your problem',
                              370,
                              200,
                              _message,
                              IconButton(
                                  onPressed: () {}, icon: const Icon(null)),
                              200 ~/ 20,
                              false,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const CustomText(
                                    message: 'Evidence of the problem: ',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    //Call bottom modal imagepicker gallery or camera
                                    CustomButton(
                                      buttonName: 'Upload File',
                                      backgroundColorButton:
                                          AppColors.cardAttendance,
                                      borderColor: AppColors.secondaryText,
                                      textColor: AppColors.primaryButton,
                                      colorShadow: Colors.transparent,
                                      function: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (builder) =>
                                                bottomSheet());
                                      },
                                      height: 35,
                                      width: 100,
                                      fontSize: 12,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: _imageFile != null
                                    ? Image(
                                        width: 300,
                                        height: 200,
                                        image:
                                            FileImage(File(_imageFile!.path)))
                                    : Container()),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 13),
                                child: CustomButton(
                                    buttonName: 'Send',
                                    backgroundColorButton:
                                        AppColors.primaryButton,
                                    colorShadow: AppColors.colorShadow,
                                    borderColor: Colors.transparent,
                                    textColor: Colors.white,
                                    function: () {},
                                    height: 50,
                                    width: 370,
                                    fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  SizedBox customFormField(
      String hintText,
      double width,
      double height,
      TextEditingController textEditingController,
      IconButton iconButton,
      int maxLines,
      bool readOnly) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        maxLines: maxLines,
        readOnly: readOnly,
        controller: textEditingController,
        keyboardType: TextInputType.text,
        style: const TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.normal,
            fontSize: 15),
        obscureText: false,
        decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: iconButton,
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(92, 190, 188, 188))),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(width: 1, color: AppColors.primaryButton),
            )),
      ),
    );
  }

  Widget noChange() {
    return Container();
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            'Choose Your Photo',
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Gallery'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }
}
