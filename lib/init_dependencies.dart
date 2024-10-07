import 'package:flutter_bloc_master/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_bloc_master/core/network/connection_checker.dart';
import 'package:flutter_bloc_master/core/secrets/app_secrets.dart';
import 'package:flutter_bloc_master/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_bloc_master/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/user_login.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter_bloc_master/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc_master/features/blog/data/datasource/blog_local_data_source.dart';
import 'package:flutter_bloc_master/features/blog/data/datasource/blog_remote_data_source.dart';
import 'package:flutter_bloc_master/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:flutter_bloc_master/features/blog/domain/repository/blog_repository.dart';
import 'package:flutter_bloc_master/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:flutter_bloc_master/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter_bloc_master/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonkey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerFactory(() => InternetConnection());
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));
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
          appUserCubit: serviceLocator()),
    );
}

void _initBlog() {
  serviceLocator
    //Data Source
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Usecase
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
