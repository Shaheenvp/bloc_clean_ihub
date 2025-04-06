import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/user_data.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserModel>>> getUsers({int page = 1});

  Future<Either<Failure, UserModel>> getUserById(int userId);

  Future<Either<Failure, UserModel>> createUser(UserModel user);

  Future<Either<Failure, UserModel>> updateUser(UserModel user);

  Future<Either<Failure, void>> deleteUser(int userId);

  Future<Either<Failure, List<UserModel>>> searchUsers(String query);
}
