import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/user_data.dart';
import '../repository/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, List<UserModel>>> call({int page = 1}) async {
    return await repository.getUsers(page: page);
  }
}
