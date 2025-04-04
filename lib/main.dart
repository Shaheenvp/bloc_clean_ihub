import 'package:bloc_clean_ihub_test/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/theme.dart';
import 'features/users/presentation/bloc/user_bloc.dart';
import 'features/users/presentation/bloc/user_event.dart';
import 'features/users/presentation/views/user_listing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => di.getIt<UserBloc>()..add(LoadUsers()),
          child: MaterialApp(
            title: 'User Management App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: child,
          ),
        );
      },
      child: const UserListScreen(),
    );
  }
}
