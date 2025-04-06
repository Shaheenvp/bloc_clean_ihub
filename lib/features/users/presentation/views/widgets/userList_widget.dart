import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/ui_consts.dart';
import '../../bloc/user_bloc.dart';
import '../../bloc/user_event.dart';
import '../userDetail_screen.dart';
import '../editUser_screen.dart';
import 'actionButton_widget.dart';

class UserListItem extends StatelessWidget {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String status;

  const UserListItem({
    super.key,
    required this.name,
    required this.id,
    required this.email,
    required this.gender,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = _getProfessionalBusinessAvatarUrl();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailsScreen(
                  userId: id,
                  avatarUrl: avatarUrl,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                _buildAvatar(avatarUrl),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          _buildStatusIndicator(),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ActionButton(
                            icon: Icons.edit_outlined,
                            label: 'Edit',
                            color: AppColors.primaryDark,
                            onTap: () => _navigateToEditScreen(context),
                          ),
                          SizedBox(width: 12.w),
                          ActionButton(
                            icon: Icons.delete_outline,
                            label: 'Delete',
                            color: AppColors.error,
                            onTap: () => _showDeleteConfirmation(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String avatarUrl) {
    return Hero(
      tag: 'avatar-$id',
      child: Container(
        height: 56.r,
        width: 56.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.network(
            avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: _getAvatarColor(name),
                child: Icon(
                  Icons.business_center,
                  size: 30.r,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            status,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  String _getProfessionalBusinessAvatarUrl() {
    final int uniqueIdentifier = (id + name.hashCode) % 30;
    final bool isMale = gender.toLowerCase() == 'male';
    final List<String> maleBusinessAvatars = [
      'https://images.unsplash.com/photo-1560250097-0b93528c311a',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
      'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7',
      'https://images.unsplash.com/photo-1600486913747-55e5470d6f40',
      'https://images.unsplash.com/photo-1618077360395-f3068be8e001',
      'https://images.unsplash.com/photo-1580309237429-dba0c5f82235',
      'https://images.unsplash.com/photo-1537511446984-935f663eb1f4',
      'https://images.unsplash.com/photo-1584999734482-0361aecad844',
      'https://images.unsplash.com/photo-1614583225154-5fcdda07019e',
      'https://images.unsplash.com/photo-1545167622-3a6ac756afa4',
      'https://images.unsplash.com/photo-1512484776495-a09d92e87c3b',
      'https://images.unsplash.com/photo-1583195764036-6dc248ac07d9',
      'https://images.unsplash.com/photo-1564564321837-a57b7070ac4f',
      'https://images.unsplash.com/photo-1578496479690-722775309167',
    ];

    final List<String> femaleBusinessAvatars = [
      'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2',
      'https://images.unsplash.com/photo-1580894732444-8ecded7900cd',
      'https://images.unsplash.com/photo-1551836022-deb4988cc6c0',
      'https://images.unsplash.com/photo-1600486913747-55e5470d6f40',
      'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91',
      'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e',
      'https://images.unsplash.com/photo-1580894723150-80bc81c39fae',
      'https://images.unsplash.com/photo-1573496799652-408c2ac9fe98',
      'https://images.unsplash.com/photo-1573497019236-17f8177b81e8',
      'https://images.unsplash.com/photo-1554151228-14d9def656e4',
      'https://images.unsplash.com/photo-1558898479-33c0b87c56d8',
      'https://images.unsplash.com/photo-1598550473359-574922306fc3',
      'https://images.unsplash.com/photo-1551836022-b52324bc4f55',
      'https://images.unsplash.com/photo-1587613864521-9ef8dfe427b2',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
    ];

    final List<String> avatarList = isMale ? maleBusinessAvatars : femaleBusinessAvatars;
    final int index = uniqueIdentifier % avatarList.length;

    return '${avatarList[index]}?w=200&q=80&fit=crop&crop=faces,center';
  }

  Color _getAvatarColor(String name) {
    final List<Color> colors = [
      AppColors.primary,
      AppColors.success,
      Colors.orange,
      Colors.purple,
      AppColors.error,
      Colors.teal,
    ];

    int hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }

  void _navigateToEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(
          id: id,
          name: name,
          email: email,
          gender: gender,
          status: status,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_outline, color: AppColors.error, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Confirm delete?',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: UIConstants.textSizeXLarge),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action cannot be undone. The user and all associated data will be permanently removed.',
                style: TextStyle(fontSize: UIConstants.textSizeSmall),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Status: $status',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isDeleting
                  ? null
                  : () async {
                setState(() => isDeleting = true);

                await Future.delayed(Duration(milliseconds: 500));

                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: isDeleting
                  ? Container(
                width: 90,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CupertinoActivityIndicator(
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('Deleting...'),
                  ],
                ),
              )
                  : Container(
                width: 90,
                alignment: Alignment.center,
                child: Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    ).then(
          (value) {
        if (value != null && value == true) {
          context.read<UserBloc>().add(DeleteUserEvent(id));
        }
      },
    );
  }
}