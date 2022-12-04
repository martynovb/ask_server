import 'package:alfred/alfred.dart';
import 'package:ask_server/services/services.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

class AuthMiddleware {
  static isAuthenticated(HttpRequest req, HttpResponse res) {
    final authHeader = req.headers.value('Authorization');
    if (authHeader != null) {
      final token = authHeader.replaceAll('Bearer', '');
      if (token.isNotEmpty) {
        final parsedToken = JWT.parse(token);
        final isValid = parsedToken.verify(services.jwtSigner);
        if(!isValid) {
          throw AlfredException(401, 'invalid token');
        }

        req.store.set('token', parsedToken);

      } else {
        throw AlfredException(401, 'no token provided');
      }
    } else {
      throw AlfredException(401, 'no auth header provided');
    }
  }
}
