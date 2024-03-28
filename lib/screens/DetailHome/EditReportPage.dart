import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/CustomButton.dart';
import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ClassesStudent.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/AttendanceDetailDataForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/AttendanceFormDataForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/ReportDataForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ReportImage.dart';
import 'package:attendance_system_nodejs/providers/attendanceFormForDetailPage_data_provider.dart';
import 'package:attendance_system_nodejs/services/API.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class EditReportPage extends StatefulWidget {
  const EditReportPage({
    super.key,
    required this.classesStudent,
    required this.reportData,
  });
  final ClassesStudent classesStudent;
  final ReportData reportData;

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  final TextEditingController _lectuerController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _message = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  late ClassesStudent classesStudent;
  late ReportData reportData;
  late ProgressDialog _progressDialog;
  final _formKey = GlobalKey<FormState>();

  late Future<ReportData?> _fetchReport;
  List<String> deleteList = [];

  // Initial Selected Value

  // List of items in our dropdown menu
  var items = [
    'Device failure',
    'Personal reason',
    'Others',
  ];
  List<ReportImage?> listReportImage = [];

  final List<XFile?> _imageFiles = [];
  String dropdownvalue = 'Device failure';
  @override
  void initState() {
    super.initState();
    classesStudent = widget.classesStudent;
    reportData = widget.reportData;
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
    _fetchData();
  }

  void _fetchData() async {
    _fetchReport = API(context).viewReport(reportData.reportID);
    _fetchReport.then((value) {
      setState(() {
        listReportImage = value!.reportImage;
        _topicController.text = value.topic;
        _message.text = value.message;
      });
    });
    for (int i = 0; i < listReportImage.length; i++) {
      print(listReportImage[i]!.imageID);
    }
    print('FetchData');
  }

  void _changeImageFromURL(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        listReportImage[index]?.imageURL = pickedFile;
        if (listReportImage[index]?.imageURL is XFile) {
          _imageFiles.add(listReportImage[index]?.imageURL);
        }
        deleteList.add(listReportImage[index]!.imageID);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                // setState(() {});
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(Icons.arrow_back,
                    color: Colors.white), // Thay đổi icon và màu sắc tùy ý
              ),
            ),
            backgroundColor: AppColors.colorAppbar,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(left: 50.0, top: 0, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                      message: classesStudent.courseName,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  Row(
                    children: [
                      CustomText(
                          message: 'CourseID: ${classesStudent.courseID}',
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
                      CustomText(
                          message: 'Room: ${classesStudent.roomNumber}',
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
                      CustomText(
                          message: 'Shift: ${classesStudent.shiftNumber}',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomText(
                      message: 'Lectuer: ${classesStudent.teacherName}',
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
            // height: MediaQuery.of(context).size.height,
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: Text(
                      'Edit Report Attendance',
                      style: GoogleFonts.inter(
                          color: AppColors.primaryButton,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(
                      height: 15,
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
                                  classesStudent.teacherName,
                                  370,
                                  50,
                                  _lectuerController,
                                  IconButton(
                                      onPressed: () {}, icon: const Icon(null)),
                                  1,
                                  true, (value) {
                                return;
                              }),
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
                                  'Topic',
                                  370,
                                  50,
                                  _topicController,
                                  IconButton(
                                      onPressed: () {}, icon: const Icon(null)),
                                  1,
                                  false, (value) {
                                return;
                              }),
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
                                                  color: Color.fromARGB(
                                                      99, 0, 0, 0),
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                  false, (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your message';
                                }
                              }),
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
                                      listReportImage.length < 3 ||
                                              listReportImage.length +
                                                      _imageFiles.length <
                                                  3
                                          ? CustomButton(
                                              buttonName: 'Upload File',
                                              backgroundColorButton:
                                                  AppColors.cardAttendance,
                                              borderColor:
                                                  AppColors.secondaryText,
                                              textColor:
                                                  AppColors.primaryButton,
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
                                            )
                                          : Container(),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: [
                                    ...listReportImage
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final int index = entry.key;
                                      final ReportImage? image = entry.value;
                                      return GestureDetector(
                                        onTap: () {
                                          _changeImageFromURL(index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: image?.imageURL is XFile
                                              ? Image(
                                                  width: 220,
                                                  height: 220,
                                                  fit: BoxFit.cover,
                                                  image: FileImage(File(
                                                      image?.imageURL.path)),
                                                )
                                              : Image.network(
                                                  image?.imageURL,
                                                  width: 220,
                                                  height: 220,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      );
                                    }).toList(),
                                    ..._imageFiles.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final XFile? imageFile = entry.value;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: InkWell(
                                          onLongPress: () =>
                                              _deleteImage(index),
                                          onTap: () => _changeImage(index),
                                          child: imageFile != null
                                              ? Center(
                                                  child: Image(
                                                    width: 240,
                                                    height: 240,
                                                    fit: BoxFit.cover,
                                                    image: FileImage(
                                                        File(imageFile.path)),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      );
                                    }).toList(),
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: CustomButton(
                                      buttonName: 'Edit',
                                      backgroundColorButton:
                                          AppColors.primaryButton,
                                      colorShadow: AppColors.colorShadow,
                                      borderColor: Colors.transparent,
                                      textColor: Colors.white,
                                      function: () async {
                                        try {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _progressDialog.show();
                                            String result = await API(context)
                                                .editReport(
                                                    reportData.reportID,
                                                    _topicController.text,
                                                    dropdownvalue,
                                                    _message.text,
                                                    _imageFiles,
                                                    deleteList);
                                            if (result == '') {
                                              print('Success');
                                              await _progressDialog.hide();
                                              await _showDialog(
                                                  context,
                                                  "Edit successfully report to lectuer",
                                                  'Successfully');
                                            } else {
                                              print('failed');

                                              await _progressDialog.hide();
                                              await _showDialog(
                                                  context, result, 'Error');
                                            }
                                          }
                                        } catch (e) {
                                          print('Error send report: $e');
                                          await _showDialog(
                                              context, e.toString(), 'Error');
                                        } finally {
                                          await _progressDialog.hide();
                                        }
                                      },
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
          ),
        ));
  }

  Future<dynamic> _showDialog(
      BuildContext context, String message, String title) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          width: 200,
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            content: Text(message,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Future.delayed(const Duration(seconds: 30), () {
                  //   Navigator.of(context).pop();
                  // });
                  Navigator.pop(context);
                },
                child: const Text("OK",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 15)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteImage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Confirm",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          content: const Text("Do you want to delete image ?",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel",
                  style: TextStyle(
                      color: AppColors.primaryButton,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _imageFiles.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Yes",
                  style: TextStyle(
                      color: AppColors.importantText,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  SizedBox customFormField(
      String hintText,
      double width,
      double height,
      TextEditingController textEditingController,
      IconButton iconButton,
      int maxLines,
      bool readOnly,
      String? Function(String?) validator) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        validator: validator,
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
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(92, 190, 188, 188))),
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

  // void takePhoto(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = pickedFile;
  //     });
  //   }
  // }

  // void takePhoto(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFiles.add(pickedFile);
  //     });
  //   }
  // }

  void _changeImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFiles[index] = pickedFile;
      });
    }
  }

  void takePhoto(ImageSource source) async {
    if (_imageFiles.length < 3) {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFiles.add(pickedFile);
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Warning",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            content: const Text(
                "You only upload maximum 3 images. You can click an image and update",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  String formatDate(String date) {
    DateTime serverDateTime = DateTime.parse(date).toLocal();
    String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
    return formattedDate;
  }
}
