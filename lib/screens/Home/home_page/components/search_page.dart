import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
            message: 'Search',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        backgroundColor: AppColors.primaryButton,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  controller: searchController,
                  textInputType: TextInputType.text,
                  obscureText: false,
                  suffixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.search,
                        size: 14.sp,
                        color: AppColors.primaryText.withOpacity(0.3),
                      )),
                  hintText: 'Tìm kiếm',
                  prefixIcon: const Icon(null),
                  readOnly: false),
              100.verticalSpace,
              Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/search.png',
                  width: 250.w,
                  height: 250.h,
                ),
              ),
              10.verticalSpace,
              CustomText(
                  message: 'Tìm kiếm những thứ bạn muốn',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryText.withOpacity(0.3))
            ],
          ),
        ),
      ),
    );
  }
}
