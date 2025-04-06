import 'dart:async';

import 'package:bloc_clean_ihub_test/features/users/presentation/views/widgets/userList_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
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
  final ScrollController _scrollController = ScrollController();
  List<UserModel> _cachedUsers = [];
  bool _isLoadingMore = false;
  bool _hasReachedMax = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300.h &&
        !_hasReachedMax &&
        !_isLoadingMore) {
      _isLoadingMore = true;
      context.read<UserBloc>().add(LoadMoreUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
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
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildAppBar(),
                _buildSearchBar(),
                _buildHeader(),
                _buildContent(state),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading:  Center(
        child: Text(
          'Users Management',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 21.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      leadingWidth: 220.w,
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: AppColors.primaryDark,
            size: 20.sp,
          ),
          onPressed: () {
            _cachedUsers = [];
            _hasReachedMax = false;
            context.read<UserBloc>().add(LoadUsers());
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people_alt_rounded,
                  color: AppColors.primaryDark,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Users List',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    '${_cachedUsers.length} users',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          height: 50.h,
          margin: EdgeInsets.only(bottom: 16.h, top: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.grey.shade600),
                onPressed: () {
                  // Clear search and reload all users
                  context.read<UserBloc>().add(SearchUsersEvent(''));  // Update this line
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            onChanged: (value) {
              _debounceSearch(value);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(UserState state) {
    if (state is UserInitial) {
      return SliverFillRemaining(
        child: _buildEmptyState(
          icon: Icons.people_alt_outlined,
          title: 'No Users Loaded',
          subtitle: 'Tap to load users from the server',
          buttonText: 'Load Users',
          onPressed: () => context.read<UserBloc>().add(LoadUsers()),
        ),
      );
    }

    if (state is UsersLoading && _cachedUsers.isEmpty) {
      return SliverFillRemaining(
        child: _buildLoadingState(),
      );
    }

    if (state is UserError && _cachedUsers.isEmpty) {
      return SliverFillRemaining(
        child: _buildErrorState(state.message),
      );
    }

    if (_cachedUsers.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(
          icon: Icons.person_off_outlined,
          title: 'No Users Found',
          subtitle: 'There are no users available',
          buttonText: 'Refresh',
          onPressed: () => context.read<UserBloc>().add(LoadUsers()),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          if (index >= _cachedUsers.length) {
            return _isLoadingMore
                ? Center(
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: const CupertinoActivityIndicator(),
              ),
            )
                : const SizedBox.shrink();
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
        childCount: _cachedUsers.length + (_hasReachedMax ? 0 : 1),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(),
          SizedBox(height: 16.h),
          Text(
            'Loading users...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error Loading Users',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade300,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () => context.read<UserBloc>().add(LoadUsers()),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToAddScreen(),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.person_add_alt_1_rounded,color: AppColors.background,),
      label: const Text('Add User',style: TextStyle(color: AppColors.background),),
    );
  }

  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddUserScreen()),
    );
  }
  Timer? _debounceTimer;

  void _debounceSearch(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<UserBloc>().add(SearchUsersEvent(value));
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
