import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/config/theme/app_colors.dart';

Widget loadingIndicatorProgressBar({String? data}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          backgroundColor: greenColor,
        ),
        SizedBox(
          height: 10.sp,
        ),
        Text(
          data ?? "Setting up your account please wait..",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        )
      ],
    ),
  );
}

void snackBarNetwork({String? msg, GlobalKey<ScaffoldState>? scaffoldState}) {
  ScaffoldMessenger.of(scaffoldState!.currentContext!).showSnackBar(
    SnackBar(
      backgroundColor: greenColor,
      duration: const Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("$msg"), const Icon(Icons.error)],
      ),
    ),
  );
}

void snackBar(
    {required String msg, required GlobalKey<ScaffoldState> scaffoldState}) {
  ScaffoldMessenger.of(scaffoldState.currentContext!).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            msg,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const CircularProgressIndicator(),
        ],
      ),
    ),
  );
}

void push({required BuildContext context, required Widget widget}) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: greenColor,
      textColor: whiteColor,
      fontSize: 16.sp);
}
