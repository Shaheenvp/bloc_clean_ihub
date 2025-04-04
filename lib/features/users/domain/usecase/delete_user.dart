import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repository/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, void>> call(int userId) async {
    return await repository.deleteUser(userId);
  }
}