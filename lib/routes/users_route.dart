import 'package:alfred/alfred.dart';
import 'package:ask_server/services/services.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:dbcrypt/dbcrypt.dart';

class UsersRoute {
  static currentUser(HttpRequest req, HttpResponse res) async {
    final userToken = req.store.get('token') as JWT?;
    if (userToken != null) {
      final data = userToken.getClaim('data') as Map;
      final userEmail = data['email'];
      final foundUser =
          await services.usersService.findUserByEmail(email: userEmail);
      if (foundUser != null) {
        return foundUser;
      } else {
        throw AlfredException(401, {'message': 'invalid token'});
      }
    }
  }

  static login(HttpRequest req, HttpResponse res) async {
    try {
      final body = await req.bodyAsJsonMap;
      final user = await services.usersService.findUserByEmail(
        email: body['email'],
      );

      if (user == null) {
        throw AlfredException(401, {'message': 'invalid user'});
      }

      final isCorrect = DBCrypt().checkpw(body['password'], user.password);

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
    } on AlfredException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw AlfredException(500, {'message': 'unexpected exception ($e)'});
    } catch (e) {
      throw AlfredException(500, {'message': 'unexpected error ($e)'});
    }
  }

  static createAccount(HttpRequest req, HttpResponse res) {}
}
