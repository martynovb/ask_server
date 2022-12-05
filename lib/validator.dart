import 'package:alfred/alfred.dart';
import 'package:ask_server/models/user.dart';

bool isUserValid(User? user) {
  if (user == null) {
    throw AlfredException(401, {'message': 'invalid user'});
  } else if (user.email == null ||
      user.email!.isEmpty ||
      user.password == null ||
      user.password!.isEmpty) {
    throw AlfredException(401, {'message': 'invalid user data'});
  }
  return true;
}
