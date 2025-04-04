import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/execeptions.dart';
import '../models/user_data.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers({int page = 1, int perPage = 5});

  Future<UserModel> getUser(int id);

  Future<UserModel> createUser(UserModel user);

  Future<UserModel> updateUser(UserModel user);

  Future<void> deleteUser(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getUsers({int page = 1, int perPage = 5}) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}?page=$page&per_page=$perPage'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw ServerException(
        message: 'Failed to load users: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<UserModel> getUser(int id) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$id'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw NotFoundException('User not found');
    } else {
      throw ServerException(
        message: 'Failed to load user: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 422) {
      final errorData = json.decode(response.body);

      throw ValidationException(message: errorData[0]['message']);
    } else {
      throw ServerException(
        message: 'Failed to create user: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final response = await client.put(
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/${user.id}'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw NotFoundException('User not found');
    } else if (response.statusCode == 422) {
      final errorData = json.decode(response.body);
      throw ValidationException(
        message: errorData['message'],
      );
    } else {
      throw ServerException(
        message: 'Failed to update user: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$id'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 404) {
      throw NotFoundException('User not found');
    } else {
      throw ServerException(
        message: 'Failed to delete user: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}
