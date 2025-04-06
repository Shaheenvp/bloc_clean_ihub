import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/network/network_info.dart';
import 'features/users/data/data_source/user_local_data_source.dart';
import 'features/users/data/data_source/user_remote_data_source.dart';
import 'features/users/data/respository/user_repository_impl.dart';
import 'features/users/domain/repository/user_repository.dart';
import 'features/users/domain/usecase/create_user.dart';
import 'features/users/domain/usecase/delete_user.dart';
import 'features/users/domain/usecase/get_userById.dart';
import 'features/users/domain/usecase/get_users.dart';
import 'features/users/domain/usecase/search_user.dart';
import 'features/users/domain/usecase/update_user.dart';
import 'features/users/presentation/bloc/user_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => Connectivity());

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  getIt.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    remoteDataSource: getIt(),
    localDataSource: getIt(),
    networkInfo: getIt(),
  ));

  getIt.registerLazySingleton(() => GetUsers(getIt()));
  getIt.registerLazySingleton(() => CreateUser(getIt()));
  getIt.registerLazySingleton(() => UpdateUser(getIt()));
  getIt.registerLazySingleton(() => DeleteUser(getIt()));
  getIt.registerLazySingleton(() => GetUserById(getIt()));
  getIt.registerLazySingleton(() => SearchUsers(getIt()));

  getIt.registerFactory(() => UserBloc(
    getUsers: getIt(),
    createUser: getIt(),
    updateUser: getIt(),
    deleteUser: getIt(),
    getUserById: getIt(),
    searchUsers: getIt(),
  ));
}