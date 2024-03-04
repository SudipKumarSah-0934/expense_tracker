import 'package:retrofit/retrofit.dart';

import '../../models/article_result_model.dart';

abstract class NewsRemoteDataSource {
  Future<HttpResponse<ArticleResultModel>> getTopHeadlineArticles({
    required String categoryValue,
    required String country,
  });

  Future<HttpResponse<ArticleResultModel>> searchArticles({
    required int page,
    required int pageSize,
    required String query,
  });
}
