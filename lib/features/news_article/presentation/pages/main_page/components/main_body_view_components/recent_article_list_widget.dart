import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/features/news_article/domain/entities/article.dart';
import 'package:news_app/features/news_article/presentation/pages/article_list_page.dart';
import 'package:news_app/features/news_article/presentation/widgets/article_item_widget.dart';

class RecentArticleListWidget extends StatelessWidget {
  final List<Article> articles;
  const RecentArticleListWidget({Key? key, required this.articles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Recent News',
                textSize: 20.sp,
                textColor: greenColor,
                isBold: true,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ArticleListPage.routeName);
                },
                child: CustomText(
                  text: 'View all',
                  textColor: greenColor,
                ),
              )
            ],
          ),
          8.verticalSpace,
          ArticleListWidget(articles: articles),
          8.verticalSpace,
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ArticleListPage.routeName);
            },
            child: CustomText(
              text: 'View all',
              textColor: greenColor,
            ),
          ),
          8.verticalSpace
        ],
      ),
    );
  }
}

class ArticleListWidget extends StatelessWidget {
  final List<Article> articles;
  const ArticleListWidget({Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: articles.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 4.h,
          );
        },
        itemBuilder: (context, index) {
          return ArticleItemWidget(
            article: articles[index],
          );
        });
  }
}
