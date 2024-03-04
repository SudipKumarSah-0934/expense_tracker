import 'package:flutter/material.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/core/constants/ui_constants.dart';
import 'package:news_app/features/news_article/presentation/pages/article_detail_page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../domain/entities/article.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleItemWidget extends StatelessWidget {
  final Article article;
  const ArticleItemWidget({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ArticleDetailPage.routeName,
            arguments: article);
      },
      child: Container(
        height: DEFAULT_ITEM_HEIGHT,
        padding: EdgeInsets.all(8.sp),
        child: Row(
          children: [
            _ImageWidget(imageUrl: article.urlToImage ?? ''),
            8.horizontalSpace,
            Expanded(child: _ArticleInfoWidget(article: article))
          ],
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final String imageUrl;
  const _ImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: FadeInImage.memoryNetwork(
        width: 120.w,
        height: 100.h,
        imageErrorBuilder: (context, error, stackTrace) {
          return Container(
            width: 120.w,
            height: 100.h,
            color: Colors.red.withOpacity(0.6),
            child: const Icon(Icons.error_outline_outlined),
          );
        },
        placeholder: kTransparentImage,
        image: imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ArticleInfoWidget extends StatelessWidget {
  final Article article;
  const _ArticleInfoWidget({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            article.title.trim(),
            maxLines: 3,
            style: TextStyle(
                fontSize: 14.sp,
                color: appTextColor,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 90.h,
                ),
                child: Text(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  article.source.name,
                  softWrap: true,
                  style: TextStyle(fontSize: 16.sp, color: greenColor),
                ),
              ),
              CustomText(
                text: article.formattedDate,
                textSize: 10.sp,
              )
            ],
          ),
        ),
      ],
    );
  }
}
