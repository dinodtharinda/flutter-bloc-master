import 'package:flutter/foundation.dart';

class ServerException implements Exception {
  final String message;
   ServerException([this.message = "error occured!"]){
    if (kDebugMode) {
      print(message);
    }
   }
  
}
