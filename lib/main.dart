import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_master/core/secrets/app_secrets.dart';
import 'package:flutter_bloc_master/core/theme/theme.dart';
import 'package:flutter_bloc_master/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter_bloc_master/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc_master/features/auth/presentation/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonkey,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => AuthBloc(
          userSignUp: UserSignUp(
            AuthRepositoryImpl(
              AuthRemoteDataSourceIml(supabase.client),
            ),
          ),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}
//1:40:35
