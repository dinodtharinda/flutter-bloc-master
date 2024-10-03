// ignore_for_file: avoid_print

class Failure {
  final String message;
  Failure([this.message = "a unexpected error occured"]){
    print(message);
  }
}
