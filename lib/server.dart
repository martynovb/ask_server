import 'package:alfred/alfred.dart';
import 'package:ask_server/middleware/auth_middleware.dart';
import 'package:ask_server/routes/users_route.dart';

class Server {
  final app = Alfred();

  Future<void> start() async {
    app.post(
      '/users/login',
      UsersRoute.login,
    );

    app.get(
      '/users/currentUser',
      UsersRoute.currentUser,
      middleware: [AuthMiddleware.isAuthenticated],
    );

    app.get(
      '/status',
      (req, res) => 'Server Online',
    );
    await app.listen();
  }
}
