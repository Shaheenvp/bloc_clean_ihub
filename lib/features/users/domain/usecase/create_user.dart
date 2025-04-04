import 'package:dartz/dartz.dart';

import '../../data/models/user_data.dart';
import '../repository/user_repository.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<Either<dynamic, UserModel>> call(UserModel user) async {
    return await repository.createUser(user);
  }
}