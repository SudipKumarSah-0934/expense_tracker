import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/features/news_article/presentation/widgets/loading_list_widget.dart';
import 'package:news_app/features/news_article/presentation/widgets/loading_widget.dart';
import 'package:shimmer/shimmer.dart';

class MainLoadingListWidget extends StatelessWidget {
  const MainLoadingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: backgroundGrey,
      highlightColor: Colors.grey[100]!,
      enabled: false,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LoadingWidget(
                          width: 100.w,
                        ),
                        LoadingWidget(
                          width: 100.w,
                        ),
                      ]),
                  10.verticalSpace,
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: const AspectRatio(
                          aspectRatio: 1.4, child: LoadingWidget()))
                ],
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.sp),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LoadingWidget(
                          width: 100.w,
                        ),
                        LoadingWidget(
                          width: 80.w,
                        )
                      ]),
                  10.verticalSpace,
                  const LoadingListWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
