import 'package:hive_flutter/hive_flutter.dart';

import '../../models/article_model.dart';
import 'news_local_data_source.dart';

class NewsLocalDataSourceImpl extends NewsLocalDataSource {
  @override
  Future<void> cacheArticles(
      String boxName, List<ArticleModel> articles) async {// Open the box
    final box = Hive.box<ArticleModel>(boxName);
    print(box.path);
    box.addAll(articles);
  }

  @override
  Future<void> clearCachedArticles(String boxName) async {}

  @override
  List<ArticleModel> getCachedArticles(String boxName) {
    Hive.openBox<ArticleModel>(boxName); // Open the box
    final box = Hive.box<ArticleModel>(boxName);
    return box.values.toList();
  }
}

