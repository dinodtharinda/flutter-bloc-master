import 'package:flutter_bloc_master/core/common/entities/user.dart';
import 'package:flutter_bloc_master/core/error/failures.dart';
import 'package:flutter_bloc_master/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc_master/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late UserSignUp userSignUp;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    userSignUp = UserSignUp(mockAuthRepository);
  });

  const tEmail = 'dinodtharinda2001@gmail.com';
  const tPassword = '123456784';

  final user = User(
    id: 'ec5770d4-91f3-4a8c-843c-fdf1317017a2',
    email: tEmail,
    name: 'dinod tharinda',
  );

  group('when user sign up', () {
    test('should return User on successful sign up', () async {
      // Arrange
      when(() => mockAuthRepository.signUpWithEmailPassword(
            name: user.name,
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => Right(user));

      // Act
      final result = await userSignUp(
        UserSignUpParams(
          email: tEmail,
          password: tPassword,
          name: user.name,
        ),
      );

      // Assert
      expect(result, isA<Right<Failure, User>>());
      verify(
        () => mockAuthRepository.signUpWithEmailPassword(
          name: user.name,
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
    });

    test('should return Failure on incorrect sign up credentials', () async {
      // Arrange
      when(() => mockAuthRepository.signUpWithEmailPassword(
            name: user.name,
            email: "wrongemail@example.com",
            password: "wrongpassword",
          )).thenAnswer((_) async => Left(Failure()));

      // Act
      final result = await userSignUp(
        UserSignUpParams(
          name: user.name,
          email: "wrongemail@example.com",
          password: "wrongpassword",
        ),
      );

      // Assert
      expect(result, isA<Left<Failure, User>>());
      verify(() => mockAuthRepository.signUpWithEmailPassword(
            name: user.name,
            email: "wrongemail@example.com",
            password: 'wrongpassword',
          )).called(1);
    });
  });
}
