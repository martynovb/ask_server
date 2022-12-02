import 'dart:convert';

import 'package:ask_server/server.dart';
import 'package:ask_server/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('login', () async {
    GetIt.instance.registerSingleton(Services());
    final server = Server();

    await server.start();

    final response = await http.post(
      Uri.parse('http://localhost:3000/users/login'),
      body: {'email': 'email', 'password': 'password'},
    );
    var data = {};
    try {
      data = jsonDecode(response.body);
    } catch (ex) {}
    print('response: $response');
    print('data: $data');
    expect(data['token'] != null, true);
  });
}
