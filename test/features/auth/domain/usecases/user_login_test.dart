import 'package:flutter_bloc_master/core/common/entities/user.dart';
import 'package:flutter_bloc_master/core/error/failures.dart';
import 'package:flutter_bloc_master/features/auth/data/models/user_models.dart';
import 'package:flutter_bloc_master/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/user_login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late UserLogin userLogin;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    userLogin = UserLogin(mockAuthRepository);
  });

  const tEmail = 'dinodtharinda2001@gmail.com';
  const tPassword = '123456784';

  final user = UserModel(
    id: 'ec5770d4-91f3-4a8c-843c-fdf1317017a2',
    email: tEmail,
    name: 'dinod tharinda',
  );

  group('when user login', () {
    test('should return User on successful login', () async {
      // Arrange
      when(() => mockAuthRepository.loginWithEmailPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => Right(user));

      // Act
      final result = await userLogin(
        UserLoginParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, isA<Right<Failure, User>>());
      verify(
        () => mockAuthRepository.loginWithEmailPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
    });

    test('should return Failure on incorrect login credentials', () async {
      // Arrange
      when(() => mockAuthRepository.loginWithEmailPassword(
            email: "wrongemail@example.com",
            password: "wrongpassword",
          )).thenAnswer((_) async => Left(Failure()));

      // Act
      final result = await userLogin(
        UserLoginParams(
            email: "wrongemail@example.com", password: 'wrongpassword'),
      );

      // Assert
      expect(result, isA<Left<Failure, User>>());
      verify(() => mockAuthRepository.loginWithEmailPassword(
            email: "wrongemail@example.com",
            password: 'wrongpassword',
          )).called(1);
    });
  });
}
