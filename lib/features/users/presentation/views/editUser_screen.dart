import 'package:bloc_clean_ihub_test/features/users/presentation/views/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/user_data.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/ui_consts.dart';

class EditUserScreen extends StatefulWidget {
  final int? id;
  final UserEntity? user;
  final String? name;
  final String? email;
  final String? gender;
  final String? status;

  const EditUserScreen({
    super.key,
    this.user,
    this.name,
    this.email,
    this.gender,
    this.status,
    this.id,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedGender = '';
  String _selectedStatus = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? '';
    _emailController.text = widget.email ?? '';
    _selectedGender = widget.gender ?? 'male';
    _selectedStatus = widget.status ?? 'active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UsersLoading) {
          setState(() => _isLoading = true);
        } else if (state is UserOperationSuccess) {
          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('User updated successfully!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(
                horizontal: UIConstants.paddingLarge,
                vertical: UIConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state is UserError) {
          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(
                horizontal: UIConstants.paddingLarge,
                vertical: UIConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: const Text(
            'Edit User',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: UIConstants.topRoundedBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Area with Avatar
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(UIConstants.paddingLarge),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLighter,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            color: AppColors.primaryDark,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: UIConstants.paddingMedium),
                        Text(
                          'Edit User Account',
                          style: TextStyle(
                            fontSize: UIConstants.textSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: UIConstants.paddingSmall),
                        Text(
                          'Update user details below',
                          style: TextStyle(
                            fontSize: UIConstants.textSizeSmall,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          left: UIConstants.paddingLarge,
                          right: UIConstants.paddingLarge,
                          bottom: 80,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Information section
                            Text(
                              'User Information',
                              style: TextStyle(
                                fontSize: UIConstants.textSizeMedium,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            SizedBox(height: UIConstants.paddingMedium),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CommonWidgets.buildFormField(
                                label: 'Full Name',
                                controller: _nameController,
                                icon: Icons.person,
                                validator: (value) => FormValidators.validateRequired(value, 'Name'),
                              ),
                            ),
                            SizedBox(height: UIConstants.paddingMedium),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CommonWidgets.buildFormField(
                                label: 'Email Address',
                                controller: _emailController,
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: FormValidators.validateEmail,
                              ),
                            ),
                            SizedBox(height: UIConstants.paddingLarge),
                            Text(
                              'User Settings',
                              style: TextStyle(
                                fontSize: UIConstants.textSizeMedium,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            SizedBox(height: UIConstants.paddingMedium),
                            CommonWidgets.buildDropdownField(
                              label: 'Gender',
                              value: _selectedGender,
                              icon: Icons.people,
                              items: const [
                                DropdownMenuItem(value: 'male', child: Text('Male')),
                                DropdownMenuItem(value: 'female', child: Text('Female')),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedGender = value!);
                              },
                            ),
                            SizedBox(height: UIConstants.paddingMedium),

                            CommonWidgets.buildDropdownField(
                              label: 'Account Status',
                              value: _selectedStatus,
                              icon: Icons.toggle_on,
                              items: [
                                DropdownMenuItem(
                                  value: 'active',
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppColors.success,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Active'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'inactive',
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Inactive'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedStatus = value!);
                              },
                            ),
                            SizedBox(height: UIConstants.paddingLarge),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: UIConstants.paddingLarge,
                  vertical: UIConstants.paddingMedium,
                ),
                child: CommonWidgets.buildLoadingButton(
                  isLoading: _isLoading,
                  onPressed: _updateUser,
                  text: 'Update User',
                  loadingText: 'Updating...',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUser() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = UserModel(
        id: widget.id ?? 0,
        name: _nameController.text,
        email: _emailController.text,
        gender: _selectedGender,
        status: _selectedStatus,
      );
      context.read<UserBloc>().add(UpdateUserEvent(updatedUser));
    }
  }
}