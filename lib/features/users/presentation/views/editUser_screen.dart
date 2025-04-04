import 'package:bloc_clean_ihub_test/features/users/presentation/views/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/user_data.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/ui_consts.dart';

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
          _isLoading = true;
        } else if (state is UserOperationSuccess) {
          _isLoading = false;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('User updated successfully!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(UIConstants.borderRadiusSmall),
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state is UserError) {
          _isLoading = false;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(UIConstants.borderRadiusSmall),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title:
              const Text('Back', style: TextStyle(color: AppColors.textLight)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: UIConstants.paddingLarge),
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
              SizedBox(height: UIConstants.paddingLarge),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: UIConstants.paddingLarge),
                child: Row(
                  children: [
                    Container(
                      width: UIConstants.avatarSizeMedium,
                      height: UIConstants.avatarSizeMedium,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLighter,
                        shape: BoxShape.circle,
                        boxShadow: UIConstants.buttonShadow,
                      ),
                      child: Icon(Icons.edit, color: AppColors.primaryDark),
                    ),
                    SizedBox(width: UIConstants.paddingMedium),
                    Text(
                      'Edit Details',
                      style: TextStyle(
                        fontSize: UIConstants.textSizeXLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: UIConstants.paddingLarge),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: UIConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidgets.buildFormField(
                        label: 'Name',
                        controller: _nameController,
                        icon: Icons.person,
                        validator: (value) =>
                            FormValidators.validateRequired(value, 'Name'),
                      ),
                      SizedBox(height: UIConstants.paddingLarge),
                      CommonWidgets.buildFormField(
                        label: 'Email Address',
                        controller: _emailController,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormValidators.validateEmail,
                      ),
                      SizedBox(height: UIConstants.paddingLarge),
                      CommonWidgets.buildDropdownField<String>(
                        label: 'Gender',
                        value: _selectedGender,
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(
                              value: 'female', child: Text('Female')),
                        ],
                        onChanged: (value) {
                          _selectedGender = value!;
                        },
                        icon: Icons.people,
                      ),
                      SizedBox(height: UIConstants.paddingLarge),
                      CommonWidgets.buildDropdownField<String>(
                        label: 'Status',
                        value: _selectedStatus,
                        items: const [
                          DropdownMenuItem(
                              value: 'active', child: Text('Active')),
                          DropdownMenuItem(
                              value: 'inactive', child: Text('Inactive')),
                        ],
                        onChanged: (value) {
                          _selectedStatus = value!;
                        },
                        icon: Icons.track_changes,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(UIConstants.paddingLarge),
                child: CommonWidgets.buildLoadingButton(
                  isLoading: _isLoading,
                  onPressed: _updateUser,
                  text: 'Update Details',
                  loadingText: 'Updating...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateUser() {
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
