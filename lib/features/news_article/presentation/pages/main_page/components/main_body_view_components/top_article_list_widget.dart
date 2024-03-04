import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/core/constants/screen_padding.dart';
import 'package:news_app/features/news_article/domain/entities/article.dart';
import 'package:news_app/features/news_article/presentation/pages/article_detail_page.dart';
import 'package:transparent_image/transparent_image.dart';

class TopArticleListWidget extends StatefulWidget {
  final List<Article> articles;

  const TopArticleListWidget({Key? key, required this.articles})
      : super(key: key);

  @override
  State<TopArticleListWidget> createState() => TopArticleListWidgetState();
}

class TopArticleListWidgetState extends State<TopArticleListWidget> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return ScreenPadding(
      childWidget: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Top News',
                textSize: 30.sp,
                textColor: greenColor,
                isBold: true,
              ),
              Row(
                  children: widget.articles.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(
                            _currentIndex == entry.key ? 0.8 : 0.4)),
                  ),
                );
              }).toList())
            ],
          ),
          4.verticalSpace,
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
                aspectRatio: 1.4,
                initialPage: 0,
                autoPlay: true,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
            items: List.generate(
                widget.articles.length,
                (index) => _TopArticleItemWidget(
                      article: widget.articles[index],
                    )),
          )
        ],
      ),
    );
  }
}

class _TopArticleItemWidget extends StatelessWidget {
  final Article article;
  const _TopArticleItemWidget({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ArticleDetailPage.routeName,
            arguments: article);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.all(8.sp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FadeInImage.memoryNetwork(
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.red.withOpacity(0.4),
                    child: const Icon(Icons.error_outline_outlined),
                  );
                },
                placeholder: kTransparentImage,
                image: article.urlToImage ?? '',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8)
                ], stops: const [
                  0.4,
                  0.9
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                      text: article.title,
                      textSize: 16.sp,
                      textColor: whiteColor,
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 150.w),
                          child: CustomText(
                            text: article.source.name,
                            textSize: 16.sp,
                            textColor: greenColor,
                            isBold: true,
                          ),
                        ),
                        10.horizontalSpace,
                        CustomText(
                          text: article.formattedDate,
                          textColor: Colors.white,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
