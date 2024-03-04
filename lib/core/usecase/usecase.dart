import 'package:news_app/core/resources/data_state.dart';

abstract class Usecase<T, P> {
  Future<DataState<T>> call(P p);
}
