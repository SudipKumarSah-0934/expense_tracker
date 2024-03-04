import '../entities/user_entity.dart';
import '../repository/firebase_repository.dart';

class SignInUseCase{
  final FirebaseRepository repository;

  SignInUseCase({required this.repository});

  Future<void> call(UserEntity user){
    return repository.signIn(user);
  }
}