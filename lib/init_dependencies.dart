import 'package:flutter_bloc_master/core/secrets/app_secrets.dart';
import 'package:flutter_bloc_master/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_bloc_master/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/user_login.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter_bloc_master/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonkey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator
    //Data Source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceIml(
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    //Usecase
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    //Usecase
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
      ),
    );
}
