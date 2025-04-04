
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/execeptions.dart';
import '../models/user_data.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getLastUsers();
  Future<void> cacheUsers(List<UserModel> users);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    try {
      final jsonString = json.encode(users.map((e) => e.toJson()).toList());
      await sharedPreferences.setString('CACHED_USERS', jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<UserModel>> getLastUsers() async {
    final jsonString = sharedPreferences.getString('CACHED_USERS');
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } catch (e) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }
}