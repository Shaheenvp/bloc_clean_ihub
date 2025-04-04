import 'package:equatable/equatable.dart';

import '../../data/models/user_data.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {
  final bool isInitialLoad;

  const LoadUsers({this.isInitialLoad = true});
}

class LoadMoreUsers extends UserEvent {}

class AddUser extends UserEvent {
  final UserModel user;

  const AddUser(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateUserEvent extends UserEvent {
  final UserModel user;

  const UpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class DeleteUserEvent extends UserEvent {
  final int userId;

  const DeleteUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadUser extends UserEvent {
  final int userId;

  const LoadUser(this.userId);

  @override
  List<Object> get props => [userId];
}
