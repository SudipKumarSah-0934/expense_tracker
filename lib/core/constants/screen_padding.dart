import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenPadding extends StatelessWidget {
  final Widget childWidget;
  const ScreenPadding({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: childWidget,
    );
  }
}
