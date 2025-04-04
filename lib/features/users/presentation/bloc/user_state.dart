import 'package:equatable/equatable.dart';

import '../../data/models/user_data.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UsersLoading extends UserState {}

class UserOperationInProgress extends UserState {}

class UsersLoaded extends UserState {
  final List<UserModel> users;
  final int currentPage;
  final bool hasReachedMax;

  const UsersLoaded(this.users,
      {this.currentPage = 1, this.hasReachedMax = false});
}

class SingleUserLoaded extends UserState {
  final UserModel user;

  const SingleUserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserOperationSuccess extends UserState {
  final String message;

  const UserOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
