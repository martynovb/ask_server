import 'package:alfred/alfred.dart';
import 'package:ask_server/models/user.dart';
import 'package:ask_server/services/services.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:dbcrypt/dbcrypt.dart';

class UsersRoute {
  static currentUser(HttpRequest req, HttpResponse res) {
    final user = User(email: 'test@mail.com');
    return user;
  }

  static login(HttpRequest req, HttpResponse res) async {
    try {
      print('req: $req');
    final body = await req.bodyAsJsonMap;
    final user = await services.usersService.findUserByEmail(
      email: body['email'],
    );

    if (user == null) {
      throw AlfredException(401, {'message': 'invalid user'});
    }


      final isCorrect = DBCrypt().checkpw(
          user.password ?? '', body['password']);

      if (!isCorrect) {
        throw AlfredException(401, {'message': 'wrong email or password'});
      }

      var token = JWTBuilder()
        ..issuer = 'https://api.ask.com'
        ..expiresAt = new DateTime.now().add(new Duration(days: 7))
        ..setClaim('data', {'email': user.email})
        ..getToken();

      var signer = JWTHmacSha256Signer(services.JWT_SECRET_KEY);
      var signedToken = token.getSignedToken(signer);

      return {'token': signedToken.toString()};
    } catch (ex){
      throw AlfredException(401, {'message': 'wrong email or password'});
    }
  }

  static createAccount(HttpRequest req, HttpResponse res) {}
}
