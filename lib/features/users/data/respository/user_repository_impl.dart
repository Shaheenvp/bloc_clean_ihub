import 'dart:io';

import 'package:bloc_clean_ihub_test/core/network/network_info.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/execeptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repository/user_repository.dart';
import '../data_source/user_local_data_source.dart';
import '../data_source/user_remote_data_source.dart';
import '../models/user_data.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UserModel>>> searchUsers(String query) async {
    try {
      final  isConnected = await networkInfo.isConnected;

      if (isConnected == true) {
        final remoteUsers = await remoteDataSource.getUsers();

        final filteredUsers = remoteUsers.where((user) {
          final nameMatches = user.name.toLowerCase().contains(query.toLowerCase());
          final emailMatches = user.email.toLowerCase().contains(query.toLowerCase());
          return nameMatches || emailMatches;
        }).toList();

        return Right(filteredUsers);
      } else {
        final localUsers = await localDataSource.getLastUsers();

        final filteredUsers = localUsers.where((user) {
          final nameMatches = user.name.toLowerCase().contains(query.toLowerCase());
          final emailMatches = user.email.toLowerCase().contains(query.toLowerCase());
          return nameMatches || emailMatches;
        }).toList();

        return Right(filteredUsers);
      }
    } on ServerException {
      return Left(ServerFailure('Server error occurred'));
    } on CacheException {
      return Left(CacheFailure('Cache error occurred'));
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, List<UserModel>>> getUsers({int page = 1}) async {
    if (await networkInfo.isConnected()) {
      try {
        final remoteUsers = await remoteDataSource.getUsers(page: page);

        if (page == 1) {
          await localDataSource.cacheUsers(remoteUsers);
        }

        return Right(remoteUsers);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException {
        return Left(NetworkFailure('No internet connection'));
      }
    } else {
      try {
        final localUsers = await localDataSource.getLastUsers();
        return Right(localUsers);
      } on CacheException {
        return Left(CacheFailure('No cached data available'));
      }
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(int userId) async {
    if (await networkInfo.isConnected()) {
      try {
        final remoteUser = await remoteDataSource.getUser(userId);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException {
        return Left(NetworkFailure('No internet connection'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser(int id) async {
    if (await networkInfo.isConnected()) {
      try {
        UserModel remoteUser;
        remoteUser = await remoteDataSource.getUser(id);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NotFoundException {
        return Left(NotFoundFailure('User not found'));
      } on SocketException {
        return Left(NetworkFailure('No internet connection'));
      }
    } else {
      try {
        final localUsers = await localDataSource.getLastUsers();
        var user = null;
        user = localUsers.firstWhere((user) => user.id == id);
        return Right(user);
      } on CacheException {
        return Left(CacheFailure('No cached data available'));
      } on StateError {
        return Left(NotFoundFailure('User not found in cache'));
      }
    }
  }

  @override
  Future<Either<Failure, UserModel>> createUser(UserModel user) async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final userModel = UserModel(
        id: user.id ?? 0,
        name: user.name,
        email: user.email,
        gender: user.gender,
        status: user.status,
      );

      final createdUserModel = await remoteDataSource.createUser(userModel);

      final createdUser = UserModel(
        id: createdUserModel.id,
        name: createdUserModel.name,
        email: createdUserModel.email,
        gender: createdUserModel.gender,
        status: createdUserModel.status,
      );

      final currentUsers = await _getCurrentUsers();
      await localDataSource.cacheUsers([...currentUsers, createdUserModel]);

      return Right(createdUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(UserModel user) async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final userModel = UserModel(
        id: user.id ?? 0,
        name: user.name,
        email: user.email,
        gender: user.gender,
        status: user.status,
      );

      final updatedUserModel = await remoteDataSource.updateUser(userModel);

      final updatedUser = UserModel(
        id: updatedUserModel.id,
        name: updatedUserModel.name,
        email: updatedUserModel.email,
        gender: updatedUserModel.gender,
        status: updatedUserModel.status,
      );

      final currentUsers = await _getCurrentUsers();
      final updatedUsers = currentUsers
          .map((u) => u.id == updatedUserModel.id ? updatedUserModel : u)
          .toList();

      await localDataSource.cacheUsers(updatedUsers);

      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException {
      return Left(NotFoundFailure('User not found'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(int id) async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.deleteUser(id);
      final currentUsers = await _getCurrentUsers();
      final updatedUsers = currentUsers.where((user) => user.id != id).toList();
      await localDataSource.cacheUsers(updatedUsers);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException {
      return Left(NotFoundFailure('User not found'));
    }
  }

  Future<List<UserModel>> _getCurrentUsers() async {
    try {
      return await localDataSource.getLastUsers();
    } on CacheException {
      return [];
    }
  }
}
