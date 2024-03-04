import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/constants/ui_constants.dart';
import 'package:shimmer/shimmer.dart';
import 'loading_widget.dart';

class LoadingListWidget extends StatelessWidget {
  const LoadingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: false,
      child: ListView.separated(
        itemCount: 60,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        separatorBuilder: (context, index) => const SizedBox(
          height: 8.0,
        ),
        itemBuilder: (context, index) => const _LoadingItemWidiget(),
      ),
    );
  }
}

class _LoadingItemWidiget extends StatelessWidget {
  const _LoadingItemWidiget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(8.sp),
      height: DEFAULT_ITEM_HEIGHT,
      child: Row(
        children: [
          LoadingWidget(
            width: 120.w,
            height: 100.h,
          ),
          8.verticalSpace,
          Expanded(
            child: Column(
              children: [
                LoadingWidget(
                  height: 16.h,
                ),
                8.verticalSpace,
                LoadingWidget(
                  height: 16.h,
                ),
                8.verticalSpace,
                LoadingWidget(
                  height: 16.h,
                ),
                8.verticalSpace,
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoadingWidget(
                      width: 80.w,
                    ),
                    LoadingWidget(
                      width: 80.w,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
