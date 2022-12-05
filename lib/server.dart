import 'package:alfred/alfred.dart';
import 'package:ask_server/middleware/auth_middleware.dart';
import 'package:ask_server/routes/users_route.dart';

class Server {
  final app = Alfred();

  Future<void> start() async {
    app.post(
      '/users/signIn',
      UsersRoute.signIn,
    );

    app.get(
      '/users/currentUser',
      UsersRoute.currentUser,
      middleware: [AuthMiddleware.isAuthenticated],
    );

    app.post(
      '/users/signUp',
      UsersRoute.signUp,
    );

    app.get(
      '/status',
      (req, res) => 'Server Online',
    );
    await app.listen();
  }
}
