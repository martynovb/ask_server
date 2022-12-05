import 'package:alfred/alfred.dart';
import 'package:ask_server/models/user.dart';
import 'package:ask_server/services/services.dart';
import 'package:ask_server/validator.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:dbcrypt/dbcrypt.dart';

class UsersRoute {
  static currentUser(HttpRequest req, HttpResponse res) async {
    print('currentUser: ${req.store.get('token')}');
    final userToken = req.store.get('token') as JWT?;
    if (userToken != null) {
      final data = userToken.getClaim('data') as Map;
      final userEmail = data['email'];
      final foundUser =
          await services.usersService.findUserByEmail(email: userEmail);
      if (foundUser != null) {
        return foundUser.toJson();
      } else {
        throw AlfredException(401, {'message': 'user not found'});
      }
    } else {
      throw AlfredException(401, {'message': 'invalid token'});
    }
  }

  static signIn(HttpRequest req, HttpResponse res) async {
    try {
      final body = await req.bodyAsJsonMap;
      final user = await services.usersService.findUserByEmail(
        email: body['email'],
      );

      if (user == null || user.password == null) {
        throw AlfredException(401, {'message': 'invalid user'});
      }

      final isCorrect = DBCrypt().checkpw(body['password'], user.password!);

      if (!isCorrect) {
        throw AlfredException(401, {'message': 'wrong email or password'});
      }

      var token = JWTBuilder()
        ..issuer = 'https://api.ask.com'
        ..expiresAt = new DateTime.now().add(new Duration(days: 7))
        ..setClaim('data', {'email': user.email})
        ..getToken();

      var signedToken = token.getSignedToken(services.jwtSigner);

      return {'token': signedToken.toString()};
    } on AlfredException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw AlfredException(500, {'message': 'unexpected exception ($e)'});
    } catch (e) {
      throw AlfredException(500, {'message': 'unexpected error ($e)'});
    }
  }

  static signUp(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final newUser = User.fromJson(body);
    newUser.setPassword(body['password']);
    if (isUserValid(newUser)) {
      await newUser.save();
      return newUser;
    }
  }
}
