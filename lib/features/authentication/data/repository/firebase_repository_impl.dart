import 'package:news_app/features/authentication/data/datasources/firebase_remote_data_source.dart';
import 'package:news_app/features/authentication/domain/entities/user_entity.dart';
import 'package:news_app/features/authentication/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      await remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUId() async =>
      await remoteDataSource.getCurrentUId();

  @override
  Future<bool> isSignIn() async => await remoteDataSource.isSignIn();

  @override
  Future<void> signOut() async => await remoteDataSource.signOut();

  @override
  Stream<List<UserEntity>> getAllUsers() => remoteDataSource.getAllUsers();

  @override
  Future<void> googleAuth() async => remoteDataSource.googleAuth();

  @override
  Future<void> forgotPassword(String email) async =>
      remoteDataSource.forgotPassword(email);

  @override
  Future<void> signIn(UserEntity user) async => remoteDataSource.signIn(user);

  @override
  Future<void> signUp(UserEntity user) async => remoteDataSource.signUp(user);

  @override
  Future<void> getUpdateUser(UserEntity user) async =>
      remoteDataSource.getUpdateUser(user);
}
