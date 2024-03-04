import '../entities/user_entity.dart';
import '../repository/firebase_repository.dart';

class GetAllUsersUseCase{
  final FirebaseRepository repository;

  GetAllUsersUseCase({required this.repository});

  Stream<List<UserEntity>> call(){
    return repository.getAllUsers();
  }
}