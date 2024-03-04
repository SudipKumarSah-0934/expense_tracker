import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/features/news_article/domain/entities/category.dart';
import 'package:news_app/features/news_article/presentation/pages/article_list_page.dart';
import 'package:news_app/features/news_article/presentation/pages/category_list_page.dart';
import 'package:news_app/features/news_article/presentation/pages/search_page.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(SearchPage.routeName);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          decoration: ShapeDecoration(
              color: Colors.grey[200], shape: const StadiumBorder()),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              10.horizontalSpace,
              CustomText(
                text: 'Search News',
                textSize: 14.sp,
              )
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () async {
              final Category? category =
                  await Navigator.pushNamed(context, CategoryListPage.routeName)
                      as Category?;

              if (category != null) {
                Navigator.pushNamed(context, ArticleListPage.routeName,
                    arguments: category);
              }
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.grey,
            ))
      ],
    );
  }
}
