import 'package:alfred/alfred.dart';
import 'package:ask_server/routes/users_route.dart';

class Server {
  final app = Alfred();

  Future<void> start() async {
    app.get('users/login', UsersRoute.login);

    await app.listen();
  }
}
