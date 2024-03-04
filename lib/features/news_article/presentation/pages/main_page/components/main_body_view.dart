import 'package:flutter/material.dart';
import 'package:news_app/features/news_article/domain/entities/article.dart';
import 'package:news_app/features/news_article/presentation/pages/main_page/components/main_body_view_components/recent_article_list_widget.dart';
import 'package:news_app/features/news_article/presentation/pages/main_page/components/main_body_view_components/top_article_list_widget.dart';

class MainBodyView extends StatelessWidget {
  final List<Article> articles;
  const MainBodyView({Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopArticleListWidget(
            articles: articles.sublist(0, 5),
          ),
          RecentArticleListWidget(articles: articles.sublist(5)),
        ],
      ),
    );
  }
}
