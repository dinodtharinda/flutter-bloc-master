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

part 'init_dependencies.main.dart';