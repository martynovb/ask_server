import 'package:ask_server/services/database_service.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:get_it/get_it.dart';

import 'users_service.dart';

const JWT_SECRET_KEY = 'JWT_SECRET_KEY'; // todo make like a variable

class Services {
  UsersService usersService = UsersService();
  final jwtSigner = JWTHmacSha256Signer(JWT_SECRET_KEY);
}

Services get services => GetIt.instance.get<Services>();