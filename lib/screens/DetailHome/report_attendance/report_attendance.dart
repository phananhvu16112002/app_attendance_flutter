import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/attendance_detail_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/attendance_form_for_detail_page.dart';
import 'package:attendance_system_nodejs/providers/attendanceFormForDetailPage_data_provider.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/detail_page/detail_page.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportAttendance extends StatefulWidget {
  ReportAttendance(
      {super.key,
      required this.classesStudent,
      required this.attendanceFormDataForDetailPage});
  final ClassesStudent classesStudent;
  final AttendanceFormDataForDetailPage attendanceFormDataForDetailPage;

  @override
  State<ReportAttendance> createState() => _ReportAttendanceState();
}

class _ReportAttendanceState extends State<ReportAttendance> {
  final TextEditingController _lectuerController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _message = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  late ClassesStudent classesStudent;
  late AttendanceFormDataForDetailPage attendanceFormDataForDetailPage;
  late ProgressDialog _progressDialog;
  final _formKey = GlobalKey<FormState>();

  // Initial Selected Value

  // List of items in our dropdown menu
  var items = [
    'Device failure',
    'Personal reason',
    'Others',
  ];

  List<XFile?> _imageFiles = [];
  String dropdownvalue = 'Device failure';
  @override
  void initState() {
    super.initState();
    classesStudent = widget.classesStudent;
    attendanceFormDataForDetailPage = widget.attendanceFormDataForDetailPage;
    _progressDialog = customDialogLoading();
  }

  ProgressDialog customDialogLoading() {
    return ProgressDialog(context,
        isDismissible: false,
        customBody: Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: Colors.white),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primaryButton,
              ),
              5.verticalSpace,
              Text(
                'Loading',
                style: TextStyle(
                    fontSize: 16.sp,
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
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customAppBar(context),
            _body(context),
          ],
        ),
      ),
    ));
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: AppColors.secondaryText,
                  blurRadius: 15.0.r,
                  offset: Offset(0.0, 0.0))
            ]),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.verticalSpace,
                  Center(
                      child: Text(
                    AppLocalizations.of(context)?.report ?? 'Report Attendance',
                    style: GoogleFonts.inter(
                        color: AppColors.primaryButton,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  )),
                  18.verticalSpace,
                  CustomText(
                      message: AppLocalizations.of(context)?.send_to ?? 'Send To',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText),
                  5.verticalSpace,
                  customFormField(
                      classesStudent.teacherName,
                      _lectuerController,
                      IconButton(onPressed: () {}, icon: Icon(null)),
                      1,
                      true, (value) {
                    return;
                  }),
                  10.verticalSpace,
                  CustomText(
                      message: AppLocalizations.of(context)?.topic ?? 'Topic',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText),
                  5.verticalSpace,
                  customFormField(
                      'Attendance Form ${formatDate(attendanceFormDataForDetailPage.dateOpen)}',
                      _topicController,
                      IconButton(onPressed: () {}, icon: const Icon(null)),
                      1,
                      false, (value) {
                    return;
                  }),
                  10.verticalSpace,
                  CustomText(
                      message: AppLocalizations.of(context)?.problem_type ?? 'Type of Problem',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText),
                  5.verticalSpace,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0.r),
                      border: Border.all(
                          width: 1.w,
                          color: const Color.fromARGB(92, 190, 188, 188)),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: Container(),
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0.w),
                              child: Container(
                                // width: double.infinity,
                                child: Text(
                                  items,
                                  style: const TextStyle(
                                      color: Color.fromARGB(99, 0, 0, 0),
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
                  10.verticalSpace,
                  CustomText(
                      message: AppLocalizations.of(context)?.message ?? 'Message',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText),
                  5.verticalSpace,
                  customFormField(
                      'Description your problem',
                      _message,
                      IconButton(onPressed: () {}, icon: const Icon(null)),
                      200 ~/ 20,
                      false, (value) {
                    if (value!.isEmpty) {
                      return 'Enter your message';
                    }
                  }),
                  10.verticalSpace,
                  Row(
                    children: [
                      CustomText(
                          message: AppLocalizations.of(context)?.problem_evidence ?? 'Evidence of the problem',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      SizedBox(
                        width: 10.w,
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => bottomSheet());
                        },
                        child: Container(
                          width: 100.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                              color: AppColors.primaryButton,
                              borderRadius: BorderRadius.circular(5.r)),
                          child: Center(
                            child: CustomText(
                                message: AppLocalizations.of(context)?.upload_file ?? 'Upload File',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  10.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _imageFiles.asMap().entries.map((entry) {
                          final index = entry.key;
                          final XFile? imageFile = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: InkWell(
                              onLongPress: () => _deleteImage(index),
                              onTap: () => _changeImage(index),
                              child: imageFile != null
                                  ? Center(
                                      child: Image(
                                        width: 200.w,
                                        height: 200.h,
                                        fit: BoxFit.cover,
                                        image: FileImage(File(imageFile.path)),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: CustomButton(
                          buttonName: AppLocalizations.of(context)?.send ?? 'Send',
                          backgroundColorButton: _imageFiles.isNotEmpty
                              ? AppColors.primaryButton
                              : AppColors.primaryButton.withOpacity(0.3),
                          colorShadow: AppColors.colorShadow,
                          borderColor: Colors.transparent,
                          textColor: Colors.white,
                          function: _imageFiles.isNotEmpty
                              ? () async {
                                  try {
                                    if (_formKey.currentState!.validate()) {
                                      _progressDialog.show();
                                      String check = await API(context)
                                          .submitReport(
                                              classesStudent.classID,
                                              attendanceFormDataForDetailPage
                                                  .formID,
                                              _topicController.text.isNotEmpty
                                                  ? _topicController.text
                                                  // : 'Attendance Form',
                                                  : 'Attendance Form ${formatDate(attendanceFormDataForDetailPage.dateOpen)}',
                                              dropdownvalue,
                                              _message.text,
                                              _imageFiles);
                                      if (check == '') {
                                        print('Success');
                                        await _progressDialog.hide();
                                        await _showDialog(context,
                                            "Send successfully report to lectuer");
                                      } else {
                                        print('failed');

                                        await _progressDialog.hide();
                                        await _showDialog(context, check);
                                      }
                                    }
                                  } catch (e) {
                                    print('Error send report: $e');
                                    await _showDialog(context, e.toString());
                                  } finally {
                                    await _progressDialog.hide();
                                  }
                                }
                              : null,
                          fontSize: 18.sp),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container customAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 130,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        color: AppColors.primaryButton,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 14.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        classesStudent.courseName,
                        18.sp,
                        FontWeight.w600,
                        Colors.white,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              CustomText(
                                message: 'CourseID: ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              CustomText(
                                message: '${classesStudent.courseID} ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Container(
                            width: 1.w,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Row(
                            children: [
                              CustomText(
                                message: ' Room: ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              CustomText(
                                message: '${classesStudent.roomNumber} ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                message: 'Shift: ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              CustomText(
                                message: '${classesStudent.shiftNumber} ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            width: 1.w,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          CustomText(
                            message: ' Lecturer: ',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          CustomText(
                            message: '${classesStudent.teacherName} ',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          width: 200,
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Successfully",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            content: Text(message,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Future.delayed( Duration(seconds: 30), () {
                  //   Navigator.of(context).pop();
                  // });
                  Navigator.pop(context);
                  Navigator.pop(context);

                },
                child: Text("OK",
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
          title: Text("Confirm",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          content: Text("Do you want to delete image ?",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel",
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
              child: Text("Yes",
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
      TextEditingController textEditingController,
      IconButton iconButton,
      int maxLines,
      bool readOnly,
      String? Function(String?) validator) {
    return SizedBox(
      // width: width,
      // height: height,
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: validator,
        maxLines: maxLines,
        readOnly: readOnly,
        controller: textEditingController,
        keyboardType: TextInputType.text,
        style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.normal,
            fontSize: 14.sp),
        obscureText: false,
        decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: iconButton,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                borderSide: BorderSide(
                    width: 1.w, color: Color.fromARGB(92, 190, 188, 188))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                borderSide: BorderSide(
                    width: 1.w, color: Color.fromARGB(92, 190, 188, 188))),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
              borderSide:
                  BorderSide(width: 1.w, color: AppColors.primaryButton),
            )),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Your Photo',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text('Camera'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.camera),
                label: Text('Gallery'),
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
            title: Text(
              "Warning",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            content: Text(
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
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Widget customText(
      String title, double fontSize, FontWeight fontWeight, Color color) {
    return Text(
      title,
      style:
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
      overflow: TextOverflow.ellipsis,
    );
  }

  String formatDate(String? date) {
    if (date != null || date != "") {
      DateTime serverDateTime = DateTime.parse(date!).toLocal();
      String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
      return formattedDate;
    }
    return '';
  }
}
