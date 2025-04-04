import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/user_data.dart';
import '../repository/user_repository.dart';

class GetUserById {
  final UserRepository repository;

  GetUserById(this.repository);

  Future<Either<Failure, UserModel>> call(int userId) async {
    return await repository.getUserById(userId);
  }
}