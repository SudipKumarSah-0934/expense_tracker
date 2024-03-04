import 'package:news_app/features/authentication/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<void> getCreateCurrentUser(UserEntity user);

  Future<void> forgotPassword(String email);

  Future<void> signIn(UserEntity user);

  Future<void> signUp(UserEntity user);

  Future<void> getUpdateUser(UserEntity user);

  Future<void> googleAuth();

  Future<bool> isSignIn();

  Future<void> signOut();

  Future<String> getCurrentUId();

  Stream<List<UserEntity>> getAllUsers();
}
