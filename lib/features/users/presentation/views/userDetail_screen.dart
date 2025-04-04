import 'package:bloc_clean_ihub_test/features/users/presentation/views/widgets/common_widgets.dart';
import 'package:bloc_clean_ihub_test/injection_container.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/ui_consts.dart';
import 'editUser_screen.dart';

class UserDetailsScreen extends StatelessWidget {
  final int userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<UserBloc>()..add(LoadUser(userId)),
      child: UserDetailsView(userId: userId),
    );
  }
}

class UserDetailsView extends StatefulWidget {
  final int userId;

  const UserDetailsView({super.key, required this.userId});

  @override
  UserDetailsViewState createState() => UserDetailsViewState();
}

class UserDetailsViewState extends State<UserDetailsView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final backgroundColor =
            (state is UsersLoading || state is UserOperationInProgress)
                ? AppColors.cardBackground
                : AppColors.primary;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Back',
              style: TextStyle(
                color:
                    (state is UsersLoading || state is UserOperationInProgress)
                        ? AppColors.primary
                        : AppColors.textLight,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color:
                    (state is UsersLoading || state is UserOperationInProgress)
                        ? AppColors.primary
                        : AppColors.textLight,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, UserState state) {
    if (state is UsersLoading || state is UserOperationInProgress) {
      return const Center(child: CupertinoActivityIndicator());
    } else if (state is UserError) {
      return Center(
        child: Text(state.message, style: TextStyle(color: AppColors.primary)),
      );
    } else if (state is SingleUserLoaded) {
      final user = state.user;
      return Column(
        children: [
          SizedBox(height: UIConstants.paddingSmall),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  width: UIConstants.avatarSizeLarge,
                  height: UIConstants.avatarSizeLarge,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLighter,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.textLight, width: 3),
                  ),
                ),
                SizedBox(height: UIConstants.paddingMedium),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: UIConstants.textSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: UIConstants.paddingLarge),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(UIConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: UIConstants.topRoundedBorderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidgets.buildInfoItem(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email,
                  ),
                  SizedBox(height: UIConstants.paddingMedium),
                  CommonWidgets.buildInfoItem(
                    icon: Icons.person_outline,
                    label: 'Gender',
                    value: user.gender,
                  ),
                  SizedBox(height: UIConstants.paddingMedium),
                  Row(
                    children: [
                      CommonWidgets.buildInfoItem(
                        icon: Icons.info_outline,
                        label: 'Status',
                        value: user.status,
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: UIConstants.buttonHeight,
                    child: ElevatedButton(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              UIConstants.borderRadiusMedium),
                        ),
                      ),
                      child: Text(
                        'Edit Details',
                        style: TextStyle(
                          fontSize: UIConstants.textSizeMedium,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
