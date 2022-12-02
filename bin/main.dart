import 'package:ask_server/server.dart';

void main() async {
  final server = Server();
  await server.start();
}
