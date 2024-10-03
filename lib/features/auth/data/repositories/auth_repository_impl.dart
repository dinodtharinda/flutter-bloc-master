import 'package:flutter_bloc_master/core/error/exception.dart';
import 'package:flutter_bloc_master/core/error/failures.dart';
import 'package:flutter_bloc_master/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc_master/features/auth/domain/entities/user.dart';
import 'package:flutter_bloc_master/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(userId);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    } 
  }
}
