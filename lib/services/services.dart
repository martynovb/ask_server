import 'package:get_it/get_it.dart';

import 'users_service.dart';

class Services {
  UsersService usersService = UsersService();
}

Services get services => GetIt.instance.get<Services>();