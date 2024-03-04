import 'dart:io';
import 'package:dio/dio.dart';
import 'package:news_app/core/constants/constants.dart';
import 'package:news_app/core/constants/db_constants.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/news_repository.dart';
import '../data_sources/local/news_local_data_source.dart';
import '../data_sources/remote/news_remote_data_source.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl extends NewsRepository {
  final NetworkInfo networkInfo;
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl(
      {required this.networkInfo,
      required this.remoteDataSource,
      required this.localDataSource});

  @override
  Future<DataState<List<Article>>> getTopHeadlineArticles(
      {required int page,
      int pageSize = DEFAULT_PAGE_SIZE,
      String country = 'us'}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getTopHeadlineArticles(
           
            categoryValue: Category.GENERAL.value, // general is default
            
            country: country);

        if (response.response.statusCode == HttpStatus.ok) {
          final articleModels = response.data.articles;
          localDataSource.clearCachedArticles(headlineArticlesBoxName);
          localDataSource.cacheArticles(
              headlineArticlesBoxName, articleModels);
          return DataSuccess(
              data: articleModels.map((model) => model.toEntity()).toList());
        } else {
          return DataFailed(
            error: DioError(
              error: response.response.statusMessage,
              response: response.response,
              type: DioExceptionType.badResponse,
              requestOptions: response.response.requestOptions,
            ),
          );
        }
      } on DioException catch (e) {
        return DataFailed(error: e);
      }
    } else {
      final cachedArticles =
          localDataSource.getCachedArticles(headlineArticlesBoxName);
      return DataSuccess(
          data: cachedArticles.map((model) => model.toEntity()).toList());
    }
  }

  @override
  Future<DataState<List<Article>>> getCategorizedArticles(
      {required int page,
      required Category category,
      int pageSize = DEFAULT_PAGE_SIZE,
      String country = 'us'}) async {
    try {
      final response = await remoteDataSource.getTopHeadlineArticles(
       
          categoryValue: category.value,
         
          country: country);

      if (response.response.statusCode == HttpStatus.ok) {
        final articleModels = response.data.articles;
        return DataSuccess(
            data: articleModels.map((model) => model.toEntity()).toList());
      } else {
        return DataFailed(
          error: DioError(
            error: response.response.statusMessage,
            response: response.response,
            type: DioExceptionType.badResponse,
            requestOptions: response.response.requestOptions,
          ),
        );
      }
    } on DioError catch (e) {
      return DataFailed(error: e);
    }
  }

  @override
  Future<DataState<List<Article>>> searchArticles(
      {required int page, required int pageSize, required String query}) async {
    try {
      final response = await remoteDataSource.searchArticles(
          page: page, pageSize: pageSize, query: query);
      if (response.response.statusCode == HttpStatus.ok) {
        final models = response.data.articles;
        return DataSuccess(
            data: models.map((model) => model.toEntity()).toList());
      } else {
        return DataFailed(
          error: DioError(
            error: response.response.statusMessage,
            response: response.response,
            type: DioExceptionType.badResponse,
            requestOptions: response.response.requestOptions,
          ),
        );
      }
    } on DioError catch (e) {
      return DataFailed(error: e);
    }
  }
}
