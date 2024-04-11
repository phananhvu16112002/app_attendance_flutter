import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonName,
    required this.backgroundColorButton,
    required this.borderColor,
    required this.textColor,
    required this.function,
    this.height,
    this.width,
    required this.fontSize,
    required this.colorShadow,
  });

  final String buttonName;
  final Color backgroundColorButton;
  final Color borderColor;
  final Color textColor;
  final void Function()? function;
  final double? height;
  final double? width;
  final double fontSize;
  final Color colorShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        // height: height,
        width: double.infinity,
        decoration: BoxDecoration(
            color: backgroundColorButton,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(width: 1.w, color: borderColor),
            boxShadow: [
              BoxShadow(
                  color: colorShadow, blurRadius: 4, offset: const Offset(0, 1))
            ]),
        child: Center(
          child: Text(
            buttonName,
            style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor),
          ),
        ),
      ),
    );
  }
}
