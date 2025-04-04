import 'package:flutter/material.dart';
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
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: UIConstants.paddingMedium,
          vertical: UIConstants.paddingSmall),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(UIConstants.paddingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'avatar-$name',
              child: Container(
                height: UIConstants.avatarSizeLarge * 0.6,
                width: UIConstants.avatarSizeLarge * 0.6,
                decoration: BoxDecoration(
                  color: _getAvatarColor(name),
                  borderRadius:
                      BorderRadius.circular(UIConstants.borderRadiusXLarge),
                  border: Border.all(
                    color: AppColors.cardBackground,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(width: UIConstants.paddingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: UIConstants.textSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: UIConstants.paddingMedium),
                  Row(
                    children: [
                      ActionButton(
                        icon: Icons.edit_outlined,
                        label: 'Edit',
                        color: AppColors.primaryDark,
                        onTap: () {
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
                        },
                      ),
                      SizedBox(width: UIConstants.paddingSmall),
                      ActionButton(
                        icon: Icons.visibility_outlined,
                        label: 'View',
                        color: AppColors.success,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailsScreen(
                                userId: id,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: UIConstants.paddingSmall),
                      ActionButton(
                        icon: Icons.delete_outline,
                        label: 'Delete',
                        color: AppColors.error,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete $name?'),
                              content: Text(
                                  'Are you sure you want to delete this user?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                  ),
                                  child: Text(
                                    'Delete',
                                    style:
                                        TextStyle(color: AppColors.textLight),
                                  ),
                                ),
                              ],
                            ),
                          ).then(
                            (value) {
                              if (value != null && value == true) {
                                context
                                    .read<UserBloc>()
                                    .add(DeleteUserEvent(id));
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
