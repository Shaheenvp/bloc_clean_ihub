import 'package:bloc_clean_ihub_test/features/users/presentation/views/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/ui_consts.dart';
import '../../data/models/user_data.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({
    super.key,
  });

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedGender = 'male';
  String _selectedStatus = 'active';
  bool _isLoading = false;

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
              content: const Text('User added successfully!'),
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
          title: const Text('Back'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
        ),
        body: Container(
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
                      child:
                          Icon(Icons.person_add, color: AppColors.primaryDark),
                    ),
                    SizedBox(width: UIConstants.paddingMedium),
                    Text(
                      'Add New User',
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
                child: Form(
                  key: _formKey,
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
                          label: 'Email',
                          controller: _emailController,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: FormValidators.validateEmail,
                        ),
                        SizedBox(height: UIConstants.paddingLarge),
                        CommonWidgets.buildDropdownField<String>(
                          label: 'Gender',
                          value: _selectedGender,
                          icon: Icons.people,
                          items: const [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('Female'),
                            ),
                          ],
                          onChanged: (value) {
                            _selectedGender = value!;
                          },
                        ),
                        SizedBox(height: UIConstants.paddingLarge),
                        CommonWidgets.buildDropdownField<String>(
                          label: 'Status',
                          value: _selectedStatus,
                          icon: Icons.track_changes,
                          items: const [
                            DropdownMenuItem(
                              value: 'active',
                              child: Text('Active'),
                            ),
                            DropdownMenuItem(
                              value: 'inactive',
                              child: Text('Inactive'),
                            ),
                          ],
                          onChanged: (value) {
                            _selectedStatus = value!;
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(UIConstants.paddingLarge),
                child: CommonWidgets.buildLoadingButton(
                  isLoading: _isLoading,
                  onPressed: _validateAndAddUser,
                  text: 'Add User',
                  loadingText: 'Adding...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndAddUser() {
    if (_formKey.currentState!.validate()) {
      final newUser = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        gender: _selectedGender,
        status: _selectedStatus,
      );
      context.read<UserBloc>().add(AddUser(newUser));
    }
  }
}
