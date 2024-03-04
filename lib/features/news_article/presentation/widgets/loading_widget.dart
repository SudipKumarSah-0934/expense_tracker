import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingWidget extends StatelessWidget {
  final double? width, height;
  const LoadingWidget({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10.r)),
    );
  }
}
