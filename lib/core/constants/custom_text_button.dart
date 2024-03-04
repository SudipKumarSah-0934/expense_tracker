import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const CustomTextButton({
    super.key,
    required this.context,
    required this.text,
    required this.onPressed,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed,
      child: Padding(
        padding: EdgeInsets.all(2.sp),
        child: Container(
          alignment: Alignment.center,
          height: 44.sp,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: primaryColor,
          ),
          child: Text(
            text,
            style: TextStyle(
                color: whiteColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
