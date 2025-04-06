import 'package:bloc_clean_ihub_test/features/users/presentation/views/widgets/common_widgets.dart';
import 'package:bloc_clean_ihub_test/injection_container.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/ui_consts.dart';
import 'editUser_screen.dart';

class UserDetailsScreen extends StatelessWidget {
  final int userId;
  final String? avatarUrl;

  const UserDetailsScreen({super.key, required this.userId, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<UserBloc>()..add(LoadUser(userId)),
      child: UserDetailsView(userId: userId, avatarUrl: avatarUrl),
    );
  }
}

class UserDetailsView extends StatefulWidget {
  final int userId;
  final String? avatarUrl;

  const UserDetailsView({super.key, required this.userId, this.avatarUrl});

  @override
  UserDetailsViewState createState() => UserDetailsViewState();
}

class UserDetailsViewState extends State<UserDetailsView> {
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri.parse('mailto:$email');
    if (!await launchUrl(emailUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch email client'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'User Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, UserState state) {
    if (state is UsersLoading || state is UserOperationInProgress) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading profile',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (state is UserError) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red[400], size: 48),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  onPressed: () {
                    BlocProvider.of<UserBloc>(context).add(LoadUser(widget.userId));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (state is SingleUserLoaded) {
      final user = state.user;
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildUserHeader(user),
            _buildUserInfo(user),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildUserHeader(dynamic user) {
    final isActive = user.status.toLowerCase() == 'active';

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        children: [
          Hero(
            tag: 'avatar-${user.id}',
            child: Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.network(
                  widget.avatarUrl ?? _getProfessionalBusinessAvatarUrl(user),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: _getAvatarColor(user.name),
                      child: Icon(
                        Icons.person,
                        size: 50.r,
                        color: AppColors.background,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.background,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.shade400 : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.status,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.background,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(dynamic user) {
    final isActive = user.status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Text(
              'User Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          _buildInfoCard('Contact Information', [
            _buildInfoItem(
              Icons.email_outlined,
              'Email',
              user.email,
              onTap: () => _launchEmail(user.email),
              actionIcon: Icons.open_in_new,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Personal Details', [
            _buildInfoItem(
              Icons.person_outline,
              'Gender',
              user.gender,
            ),
            const Divider(height: 1),
            _buildInfoItem(
              isActive ? Icons.check_circle_outline : Icons.cancel_outlined,
              'Status',
              user.status,
              iconColor: isActive ? Colors.green : Colors.grey,
            ),
          ]),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_outlined,color: Colors.white,),
              label: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(
                      id: user.id,
                      name: user.name,
                      email: user.email,
                      gender: user.gender,
                      status: user.status,
                    ),
                  ),
                );

                if (mounted) {
                  BlocProvider.of<UserBloc>(context)
                      .add(LoadUser(widget.userId));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value,
      {Function()? onTap, IconData? actionIcon, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? AppColors.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (actionIcon != null)
              Icon(
                actionIcon,
                size: 18,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  String _getProfessionalBusinessAvatarUrl(dynamic user) {
    final int uniqueIdentifier = (user.id + user.name.hashCode) % 30;
    final bool isMale = user.gender.toLowerCase() == 'male';
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
}