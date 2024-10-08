import 'dart:convert';

import 'package:flutter_bloc_master/core/common/entities/user.dart';
import 'package:flutter_bloc_master/features/auth/data/models/user_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final userModel = UserModel(
    id: 'userId',
    email: 'example@gmail.com',
    name: 'user',
  );

  group('User model testing', () {
    test('should be a subclass of User entity', () {
      expect(userModel, isA<User>());
    });

    test('should return a valid when the json with correct data', () {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));
      // //act
      final user = UserModel.fromJson(jsonMap);
      // //assert
      expect(user, isA<UserModel>());
    });
  });
}
