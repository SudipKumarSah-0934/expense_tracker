import 'package:news_app/features/news_article/data/models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<void> cacheArticles(String boxName, List<ArticleModel> articles);
  Future<void> clearCachedArticles(String boxName);
  List<ArticleModel> getCachedArticles(String boxName);
}
