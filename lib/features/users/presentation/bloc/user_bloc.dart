import 'package:bloc/bloc.dart';
import 'package:bloc_clean_ihub_test/features/users/presentation/bloc/user_event.dart';
import 'package:bloc_clean_ihub_test/features/users/presentation/bloc/user_state.dart';

import '../../data/models/user_data.dart';
import '../../domain/usecase/create_user.dart';
import '../../domain/usecase/delete_user.dart';
import '../../domain/usecase/get_userById.dart';
import '../../domain/usecase/get_users.dart';
import '../../domain/usecase/search_user.dart';
import '../../domain/usecase/update_user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final CreateUser createUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;
  final GetUserById getUserById;
  final SearchUsers searchUsers;

  int _currentPage = 1;
  final List<UserModel> _allUsers = [];
  bool _hasReachedMax = false;

  UserBloc({
    required this.getUsers,
    required this.createUser,
    required this.updateUser,
    required this.deleteUser,
    required this.getUserById,
    required this.searchUsers,
  }) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<LoadUser>(_onLoadUserById);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onSearchUsers(SearchUsersEvent event, Emitter<UserState> emit) async {
    emit(UsersLoading());

    if (event.query.isEmpty) {
      _currentPage = 1;
      add(LoadUsers(isInitialLoad: true));
      return;
    }

    if (_allUsers.isNotEmpty) {
      final filteredUsers = _allUsers.where((user) {
        return user.name.toLowerCase().contains(event.query.toLowerCase()) ||
            user.email.toLowerCase().contains(event.query.toLowerCase());
      }).toList();

      emit(UsersLoaded(
        filteredUsers,
        currentPage: _currentPage,
        hasReachedMax: true,
        isFiltered: true,
      ));
    } else {
      emit(UserError('No users available for search'));
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    emit(UserOperationInProgress());
    try {
      final result = await createUser(event.user);
      result.fold(
        (failure) => emit(UserError(failure.toString())),
        (user) {
          if (state is UsersLoaded) {
            final currentUsers = (state as UsersLoaded).users;
            emit(UsersLoaded([...currentUsers, user]));
          }
          emit(UserOperationSuccess('User added successfully'));
          add(LoadUsers());
        },
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserOperationInProgress());
    try {
      final result = await updateUser(event.user);
      result.fold(
        (failure) => emit(UserError(failure.toString())),
        (updatedUser) {
          if (state is UsersLoaded) {
            final currentUsers = (state as UsersLoaded).users;
            final updatedUsers = currentUsers
                .map((u) => u.id == updatedUser.id ? updatedUser : u)
                .toList();
            emit(UsersLoaded(updatedUsers));
          }
          emit(UserOperationSuccess('User updated successfully'));
          add(LoadUsers()); // Refresh the list
        },
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUserById(LoadUser event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    final result = await getUserById(event.userId);
    result.fold(
      (failure) => emit(UserError(failure.toString())),
      (user) => emit(SingleUserLoaded(user)),
    );
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    if (event.isInitialLoad) {
      _currentPage = 1;
      _allUsers.clear();
      _hasReachedMax = false;
    }

    emit(UsersLoading());

    final result = await getUsers(page: _currentPage);

    result.fold((failure) => emit(UserError(failure.message)), (users) {
      _allUsers.addAll(users);
      _hasReachedMax = users.isEmpty;
      emit(UsersLoaded(List.of(_allUsers),
          currentPage: _currentPage, hasReachedMax: _hasReachedMax));
    });
  }

  Future<void> _onLoadMoreUsers(
      LoadMoreUsers event, Emitter<UserState> emit) async {
    if (_hasReachedMax) return;

    _currentPage++;

    final currentState = state;
    if (currentState is UsersLoaded) {
      emit(UserOperationInProgress());

      final result = await getUsers(page: _currentPage);

      result.fold((failure) {
        _currentPage--;
        emit(UserError(failure.message));
      }, (users) {
        if (users.isEmpty) {
          _hasReachedMax = true;
        }
        _allUsers.addAll(users);
        emit(UsersLoaded(List.of(_allUsers),
            currentPage: _currentPage, hasReachedMax: _hasReachedMax));
      });
    }
  }


  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserOperationInProgress());
    try {
      final result = await deleteUser(event.userId);
      result.fold(
        (failure) => emit(UserError(failure.toString())),
        (_) {
          if (state is UsersLoaded) {
            final currentUsers = (state as UsersLoaded).users;
            final updatedUsers =
                currentUsers.where((u) => u.id != event.userId).toList();
            emit(UsersLoaded(updatedUsers));
          }
          emit(UserOperationSuccess('User deleted successfully'));
          add(LoadUsers());
        },
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
