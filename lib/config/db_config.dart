import 'package:hive_flutter/hive_flutter.dart';

import '../features/news_article/data/models/article_model.dart';
import '../features/news_article/data/models/source_model.dart';
import '../core/constants/db_constants.dart';

Future<void> initDbConfig() async {
  await _initHive();
  await _registerAdapters();
  await _openBoxes();
}

Future<void> _initHive() async {
  await Hive.initFlutter();

}

Future<void> _registerAdapters() async {
  Hive.registerAdapter(SourceModelAdapter());
  Hive.registerAdapter(ArticleModelAdapter());
}

Future<void> _openBoxes() async {
  await Hive.openBox<ArticleModel>(headlineArticlesBoxName);

}
