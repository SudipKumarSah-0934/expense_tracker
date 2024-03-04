import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';

class CustomText extends StatelessWidget {
  final double? textSize;
  final Color? textColor;
  final String text;
   bool? isBold=false;
   CustomText({
    super.key,
    this.textSize,
    this.textColor,
    required this.text,
    this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: textSize ?? 16.sp,
          fontWeight: isBold==false ? FontWeight.normal : FontWeight.w700,
          color: textColor ?? appTextColor),
    );
  }
}
