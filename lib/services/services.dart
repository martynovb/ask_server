import 'package:get_it/get_it.dart';

import 'users_service.dart';

class Services {
  UsersService usersService = UsersService();

  final JWT_SECRET_KEY = 'JWT_SECRET_KEY'; // todo make like a variable
}

Services get services => GetIt.instance.get<Services>();