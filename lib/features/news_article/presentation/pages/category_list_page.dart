import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/custom_text.dart';

import '../../../../core/constants/ui_constants.dart';
import '../../domain/entities/category.dart';

class CategoryListPage extends StatelessWidget {
  static const routeName = '/categoryList';

  const CategoryListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
              ),
              CustomText(
                text: 'Filter News Category',
                textSize: 20.sp,
                isBold: true,
              ),
              10.verticalSpace,
              ...Category.values
                  .map((category) => _CategoryItemWidget(category: category))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItemWidget extends StatelessWidget {
  final Category category;
  const _CategoryItemWidget({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(category);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
        alignment: Alignment.center,
        child: CustomText(
          text: category.title,
          textColor: greenColor,
          textSize: 18.sp,
        ),
      ),
    );
  }
}
