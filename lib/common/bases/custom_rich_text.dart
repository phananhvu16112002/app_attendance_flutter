import 'package:flutter/material.dart';

class customRichText extends StatelessWidget {
  const customRichText({
    super.key,
    required this.title,
    required this.message,
    required this.fontWeightTitle,
    required this.fontWeightMessage,
    required this.colorText,
    required this.fontSize,
  });

  final String title;
  final String message;
  final FontWeight fontWeightTitle;
  final FontWeight fontWeightMessage;
  final Color colorText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: title,
        style: TextStyle(
          fontWeight: fontWeightTitle,
          fontSize: fontSize,
          color: colorText,
        ),
      ),
      TextSpan(
        text: message,
        style: TextStyle(
          fontWeight: fontWeightMessage,
          fontSize: fontSize,
          color: colorText,
        ),
      ),
    ]));
  }
}
