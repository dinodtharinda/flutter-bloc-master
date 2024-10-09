import 'package:flutter_bloc_master/core/error/exception.dart';
import 'package:flutter_bloc_master/core/error/failures.dart';
import 'package:flutter_bloc_master/core/network/connection_checker.dart';
import 'package:flutter_bloc_master/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc_master/features/auth/data/models/user_models.dart';
import 'package:flutter_bloc_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_bloc_master/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late AuthRepository authRepository;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepository = AuthRepositoryImpl(
      mockAuthRemoteDataSource,
      ConnectionCheckerImpl(
        InternetConnection(),
      ),
    );
  });

  const tEmail = 'dinodtharinda2001@gmail.com';
  const tPassword = '123456784';

  final user = UserModel(
    id: 'ec5770d4-91f3-4a8c-843c-fdf1317017a2',
    email: tEmail,
    name: 'dinod tharinda',
  );

  group('Auth Repository Testing ', () {
    group('Login Testing', () {
      test('should return User on successful login', () async {
        //arrange
        when(() => mockAuthRemoteDataSource.loginWithEmailPassword(
            email: tEmail, password: tPassword)).thenAnswer((_) async => user);

        //act
        final result = await authRepository.loginWithEmailPassword(
          email: tEmail,
          password: tPassword,
        );

        //assert
        result.fold(
          (l) {
            expect(l, isA<Failure>());
          },
          (r) {
            expect(r, user);
          },
        );
      });

      test('should return User on fail login', () async {
        //arrange
        when(() => mockAuthRemoteDataSource.loginWithEmailPassword(
            email: tEmail,
            password: 'wrongpassword')).thenThrow( ServerException());

        //act
        final result = await authRepository.loginWithEmailPassword(
          email: tEmail,
          password: 'wrongpassword',
        );

        //assert
        result.fold(
          (l) {
            expect(l, isA<Failure>());
          },
          (r) {
            expect(r, user);
          },
        );
      });
    });

    group('Sign up Testing', () {
      test('should return User on successful sign up', () async {
        //arrange
        when(() => mockAuthRemoteDataSource.signUpWithEmailPassword(
            email: tEmail, password: tPassword,name: user.name)).thenAnswer((_) async => user);

        //act
        final result = await authRepository.signUpWithEmailPassword(
          name: user.name,
          email: tEmail,
          password: tPassword,
        );

        //assert
        result.fold(
          (l) {
            expect(l, isA<Failure>());
          },
          (r) {
            expect(r, user);
          },
        );
      });

      test('should return User on fail sign up', () async {
        //arrange
        when(() => mockAuthRemoteDataSource.signUpWithEmailPassword(
            name: user.name,
            email: tEmail,
            password: 'wrongpassword')).thenThrow( ServerException());

        //act
        final result = await authRepository.signUpWithEmailPassword(
          name:user.name,
          email: tEmail,
          password: 'wrongpassword',
        );

        //assert
        result.fold(
          (l) {
            expect(l, isA<Failure>());
          },
          (r) {
            expect(r, user);
          },
        );
      });
    });
  });
}
