import 'package:retrofit/dio.dart';

import '../../models/article_result_model.dart';
import 'news_api.dart';
import 'news_remote_data_source.dart';

class NewsRemoteDataSourceImpl extends NewsRemoteDataSource {
  final NewsApi newsApi;

  NewsRemoteDataSourceImpl({required this.newsApi});

  @override
  Future<HttpResponse<ArticleResultModel>> getTopHeadlineArticles(
      {
      required String categoryValue,
      required String country}) {
    return newsApi.getTopHeadlineArticles(
      
        country: country,
        category: categoryValue);
  }

  @override
  Future<HttpResponse<ArticleResultModel>> searchArticles(
      {required int page, required int pageSize, required String query}) {
    return newsApi.searchArticles(
        page: page, pageSize: pageSize, qInTitle: query);
  }
}
