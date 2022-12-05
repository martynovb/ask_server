import 'package:ask_server/server.dart';
import 'package:ask_server/services/database_service.dart';
import 'package:ask_server/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  final db = await Db.create(
      'mongodb+srv://ask_user:<44Lp4921!>@atlascluster.4xlnapc.mongodb.net/askdb?retryWrites=true&w=majority');
  GetIt.instance.registerSingleton(DatabaseService(db));
  GetIt.instance.registerSingleton(Services());

  await database.open();
  await Server().start();
}
