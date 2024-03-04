
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_app/core/constants/constants.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/usecases/search_articles_usecase.dart';
part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchArticleUsecase searchArticleUsecase;
  int page = DEFAULT_STARTPAGE;
  String currentQuery = '';

  SearchBloc(this.searchArticleUsecase) : super(const SearchState()) {
    on<_Search>((event, emit) async {
      final query = event.text;
      if (query != null && query.isNotEmpty) {
        page = DEFAULT_STARTPAGE;
        currentQuery = query;
        emit(state.copyWith(pArticles: [], pStatus: SearchStatus.loading));
        final dataState = await searchArticleUsecase(page, query);
        if (dataState is DataSuccess) {
          page++;
          final List<Article> articles = dataState.data ?? [];
          emit(state.copyWith(
              pArticles: articles,
              pStatus: SearchStatus.success,
              pHasMaxReached: articles.isEmpty));
        } else {
          emit(state.copyWith(pStatus: SearchStatus.failed, pArticles: []));
        }
      }
    });

    on<_FetchNext>((event, emit) async {
      if (state.hasMaxReached) emit(state);
      emit(state.copyWith(pStatus: SearchStatus.loading));
      final dataState = await searchArticleUsecase(page, currentQuery);
      if (dataState is DataSuccess) {
        page++;
        final articles = dataState.data ?? [];
        emit(state.copyWith(
            pArticles: List.of(state.articles)..addAll(articles),
            pStatus: SearchStatus.success,
            pHasMaxReached: articles.isEmpty));
      } else {
        emit(state.copyWith(pStatus: SearchStatus.failed));
      }
    });

    on<_Refresh>((event, emit) async {
      page = DEFAULT_STARTPAGE;
      emit(state.copyWith(
          pStatus: SearchStatus.loading, pHasMaxReached: false, pArticles: []));
      add(_Search(event.text));
    });

    on<_ClearText>((event, emit) async {
      // set search status to initial and hasMaxReached false
      emit(
          state.copyWith(pStatus: SearchStatus.initial, pHasMaxReached: false));
    });
  }
}
