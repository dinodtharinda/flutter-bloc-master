import 'package:flutter_bloc_master/core/error/exception.dart';
import 'package:flutter_bloc_master/core/secrets/app_secrets.dart';
import 'package:flutter_bloc_master/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc_master/features/auth/data/models/user_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockSupabase extends Mock implements sb.Supabase {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late sb.Supabase supabase;
  late MockSupabase mockSupabase;

  late AuthRemoteDataSource remoteDataSource;


  setUpAll(() async {
    SharedPreferences.setMockInitialValues({}); // Optional: initial values

    supabase = await sb.Supabase.initialize(
      url: AppSecrets.supabaseUrl,
      anonKey: AppSecrets.supabaseAnnonkey,
    );

    mockSupabase = MockSupabase();

    remoteDataSource = AuthRemoteDataSourceIml(supabase.client);
  });

  const tEmail = 'dinodtharinda2001@gmail.com';
  const tPassword = '12345678';

  group('Login Testing', () {
    test('login success', () async {
      //arrange
      when(() => mockSupabase.client.auth.signInWithPassword(
          password: tPassword,
          email: tEmail)).thenAnswer((invocation) async => sb.AuthResponse());
      //act
      final result = await remoteDataSource.loginWithEmailPassword(
        email: tEmail,
        password: tPassword,
      );
      //assert
      expect(result, isA<UserModel>());
    });

    test('login failed', () async {
      //arrange
      when(() => mockSupabase.client.auth.signInWithPassword(
          password: tPassword, email: tEmail)).thenThrow(ServerException());

      //actg
      final call = remoteDataSource.loginWithEmailPassword;

      // Assert that the exception is thrown
      expect(
      () async => await call(email: '3434', password: tPassword),
      throwsA(isA<ServerException>()),
    );
    });
  });
}
