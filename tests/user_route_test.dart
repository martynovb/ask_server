import 'dart:convert';

import 'package:ask_server/server.dart';
import 'package:ask_server/services/database_service.dart';
import 'package:ask_server/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  Server? server;

  setUp(() async {
    final db = await Db.create('mongodb+srv://ask_user:44Lp4921!@askcluster.snq6tog.mongodb.net/?retryWrites=true&w=majority');
    GetIt.instance.registerSingleton(DatabaseService(db));
    await database.open();
    GetIt.instance.registerSingleton(Services());
    server = Server();
    await server!.start();
  });

  tearDown(() async {
    database.close();
    GetIt.instance.unregister<DatabaseService>();
    GetIt.instance.unregister<Services>();
    if (server != null) {
      await server!.app.close();
    }
  });

  test('login', () async {
    final server = Server();

    await server.start();

    final response = await http.post(
      Uri.parse('http://localhost:3000/users/signIn/'),
      body: {'email': 'test@email.com', 'password': 'password'},
    );
    final data = jsonDecode(response.body);
    expect(data['token'] != null, true);
  });

  test('get current user', () async {
    final loginResponse = await http.post(
        Uri.parse('http://localhost:3000/users/signIn'),
        body: {'email': 'test@email.com', 'password': 'password'});
    print('loginResponse.body ${loginResponse.body}');
    final loginData = jsonDecode(loginResponse.body);
    final token = loginData['token'];
    final response = await http.get(
      Uri.parse('http://localhost:3000/users/currentUser'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print('currentUserData: ${response.body}');
    expect(response.statusCode, 200);
  });

  test('it should create an account', () async {
    final createResponse =
        await http.post(Uri.parse('http://localhost:3000/users/signUp'), body: {
      "firstName": "Test 2",
      "lastName": "test 2 surname",
      "email": "test2@email.com",
      "password": "test2pass"
    });

    print(createResponse.body);
    expect(createResponse.statusCode, 200);
  });
}
