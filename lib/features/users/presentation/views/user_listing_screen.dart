import 'package:bloc_clean_ihub_test/features/users/presentation/views/widgets/userList_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/ui_consts.dart';

import '../../data/models/user_data.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import 'addUser_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserModel> _cachedUsers = [];
  bool _isLoadingMore = false;
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: UIConstants.paddingLarge),
            _buildHeader(),
            SizedBox(height: UIConstants.paddingMedium),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: UIConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: UIConstants.topRoundedBorderRadius,
                  boxShadow: UIConstants.cardShadow,
                ),
                child: ClipRRect(
                  borderRadius: UIConstants.topRoundedBorderRadius,
                  child: BlocConsumer<UserBloc, UserState>(
                    listener: (context, state) {
                      if (state is UsersLoaded) {
                        _cachedUsers = state.users;
                        _hasReachedMax = state.hasReachedMax;
                        _isLoadingMore = false;
                      } else if (state is UserOperationInProgress) {
                        _isLoadingMore = true;
                      }
                    },
                    builder: (context, state) {
                      if (state is UserInitial) {
                        return _buildLoadUsersButton(context);
                      }

                      if (state is UsersLoading && _cachedUsers.isEmpty) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }

                      if (state is UserError && _cachedUsers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.message),
                              SizedBox(height: UIConstants.paddingMedium),
                              _buildRetryButton(context),
                            ],
                          ),
                        );
                      }

                      if (_cachedUsers.isNotEmpty) {
                        return _buildUserList(context);
                      }
                      return const Center(child: Text('No users available'));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadUsersButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No users loaded',
            style: TextStyle(
              fontSize: UIConstants.textSizeMedium,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: UIConstants.paddingMedium),
          ElevatedButton.icon(
            onPressed: () {
              context.read<UserBloc>().add(LoadUsers());
            },
            icon: Icon(Icons.refresh),
            label: Text('Load Users'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.textLight,
              padding: EdgeInsets.symmetric(
                horizontal: UIConstants.paddingLarge,
                vertical: UIConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(UIConstants.borderRadiusMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<UserBloc>().add(LoadUsers());
      },
      icon: Icon(Icons.refresh),
      label: Text('Retry'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textLight,
        padding: EdgeInsets.symmetric(
          horizontal: UIConstants.paddingMedium,
          vertical: UIConstants.paddingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: AppColors.cardBackground,
              elevation: 2,
              shadowColor: AppColors.shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(UIConstants.borderRadiusLarge),
              ),
              child: Padding(
                padding: EdgeInsets.all(UIConstants.paddingMedium),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.black12,
                        child: Icon(Icons.people, color: Colors.grey)),
                    SizedBox(width: UIConstants.paddingSmall),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.zero,
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.transparent)),
                        ),
                        child: Text(
                          'Users List',
                          style: TextStyle(
                            fontSize: UIConstants.textSizeLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: UIConstants.paddingSmall),
          FloatingActionButton(
            onPressed: () {
              _cachedUsers = [];
              _hasReachedMax = false;

              context.read<UserBloc>().add(LoadUsers());
            },
            backgroundColor: AppColors.primaryDark,
            child: Icon(Icons.refresh, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.extentAfter < 300 &&
            !_hasReachedMax &&
            !_isLoadingMore) {
          _isLoadingMore = true;
          context.read<UserBloc>().add(LoadMoreUsers());
        }
        return false;
      },
      child: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
                top: UIConstants.paddingLarge,
                bottom: UIConstants.paddingLarge),
            itemCount: _cachedUsers.length + (_hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= _cachedUsers.length) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: UIConstants.paddingMedium),
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }

              final user = _cachedUsers[index];
              return UserListItem(
                name: user.name,
                id: int.parse(user.id.toString()),
                email: user.email,
                gender: user.gender,
                status: user.status,
              );
            },
          ),
          if (_cachedUsers.isNotEmpty)
            Positioned(
              bottom: UIConstants.paddingLarge,
              right: UIConstants.paddingLarge,
              child: InkWell(
                onTap: () => _navigateToAddScreen(context),
                borderRadius:
                    BorderRadius.circular(UIConstants.borderRadiusMedium),
                child: Container(
                  padding: EdgeInsets.all(UIConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius:
                        BorderRadius.circular(UIConstants.borderRadiusMedium),
                    boxShadow: UIConstants.buttonShadow,
                  ),
                  child: Icon(
                    Icons.person_add_rounded,
                    color: AppColors.textLight,
                    size: UIConstants.iconSizeMedium,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToAddScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddUserScreen()),
    );
  }
}
