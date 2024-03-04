import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/core/constants/constants.dart';
import 'package:news_app/features/authentication/data/datasources/firebase_remote_data_source.dart';
import 'package:news_app/features/authentication/data/datasources/firebase_remote_data_source_impl.dart';
import 'package:news_app/features/authentication/data/repository/firebase_repository_impl.dart';
import 'package:news_app/features/authentication/domain/repository/firebase_repository.dart';
import 'package:news_app/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/get_all_users_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/get_create_current_user_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/get_current_uid_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/get_update_user_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/google_sign_in_useCase.dart';
import 'package:news_app/features/authentication/domain/usecases/is_sign_in_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:news_app/features/news_article/data/data_sources/remote/news_api.dart';
import 'features/authentication/presentation/bloc/auth/auth_cubit.dart';
import 'features/authentication/presentation/bloc/credential/credential_cubit.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:news_app/core/network/network_info.dart';
import 'package:news_app/features/news_article/data/data_sources/local/news_local_data_source.dart';
import 'package:news_app/features/news_article/data/data_sources/local/news_local_data_source_impl.dart';
import 'package:news_app/features/news_article/data/data_sources/remote/news_remote_data_source.dart';
import 'package:news_app/features/news_article/data/data_sources/remote/news_remote_datasource_impl.dart';
import 'package:news_app/features/news_article/data/repositories/news_repository_impl.dart';
import 'package:news_app/features/news_article/domain/repositories/news_repository.dart';
import 'package:news_app/features/news_article/domain/usecases/get_categorized_articles_usecase.dart';
import 'package:news_app/features/news_article/domain/usecases/get_headline_articles_usecase.dart';
import 'package:news_app/features/news_article/domain/usecases/search_articles_usecase.dart';
import 'package:news_app/features/news_article/presentation/blocs/list/list_bloc.dart';
import 'package:news_app/features/news_article/presentation/blocs/main/main_bloc.dart';
import 'package:news_app/features/news_article/presentation/blocs/search/search_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // NetworkConfig
  sl.registerSingleton<Dio>(Dio(BaseOptions(
    baseUrl: BASE_URL,
    headers: <String, dynamic>{'X-Api-Key': API_KEY},
    connectTimeout: const Duration(seconds: 100000),
  )));
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(DataConnectionChecker()));

// Api

  sl.registerSingleton<NewsApi>(NewsApi(sl()));

  // Cubit or bloc
  sl.registerFactory<AuthCubit>(() => AuthCubit(
        isSignInUseCase: sl.call(),
        signOutUseCase: sl.call(),
        getCurrentUIDUseCase: sl.call(),
      ));
  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
      forgotPasswordUseCase: sl.call(),
      getCreateCurrentUserUseCase: sl.call(),
      signInUseCase: sl.call(),
      signUpUseCase: sl.call(),
      googleSignInUseCase: sl.call()));

  sl.registerFactory(() => MainBloc(sl()));
  sl.registerFactory(() => ListBloc(sl()));
  sl.registerFactory(() => SearchBloc(sl()));

  //Remote DataSource
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl(sl.call(), sl.call(), sl.call()));
  sl.registerSingleton<NewsRemoteDataSource>(
      NewsRemoteDataSourceImpl(newsApi: sl()));
  sl.registerSingleton<NewsLocalDataSource>(NewsLocalDataSourceImpl());

  //Repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));
  sl.registerSingleton<NewsRepository>(NewsRepositoryImpl(
      networkInfo: sl(), remoteDataSource: sl(), localDataSource: sl()));

  //UseCases
  sl.registerLazySingleton<GoogleSignInUseCase>(
      () => GoogleSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCreateCurrentUserUseCase>(
      () => GetCreateCurrentUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUIDUseCase>(
      () => GetCurrentUIDUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
      () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetAllUsersUseCase>(
      () => GetAllUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUpdateUserUseCase>(
      () => GetUpdateUserUseCase(repository: sl.call()));
  sl.registerSingleton<GetTopHeadlineArticlesUsecase>(
      GetTopHeadlineArticlesUsecase(sl()));
  sl.registerSingleton<GetCategorizedArticlesUsecase>(
      GetCategorizedArticlesUsecase(sl()));
  sl.registerSingleton<SearchArticleUsecase>(SearchArticleUsecase(sl()));

  //External
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
  sl.registerLazySingleton(() => googleSignIn);
}
