import 'package:ask_server/server.dart';
import 'package:ask_server/services/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  GetIt.instance.registerSingleton(Services());
  final server = Server();

  await server.start();
}
