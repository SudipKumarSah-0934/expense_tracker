import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/constants/custom_text_button.dart';

class LoadingFailedWidget extends StatelessWidget {
  final String errorMessage;
  final IconData icon;
  final VoidCallback onRetry;
  const LoadingFailedWidget(
      {Key? key,
      this.errorMessage = "Loading Failed",
      this.icon = Icons.error_outline_rounded,
      required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 60.sp,
            color: Colors.black.withOpacity(0.4),
          ),
          Text(errorMessage,
              style: TextStyle(
                  fontSize: 18.sp, color: Colors.black.withOpacity(0.5))),
          8.verticalSpace,
          CustomTextButton(
            onPressed: onRetry,
            text: 'Retry',
            context: context,
          )
        ],
      ),
    );
  }
}
