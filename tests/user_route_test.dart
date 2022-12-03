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
      Uri.parse('http://localhost:3000/users/login/'),
      body: {'email': 'email', 'password': 'password'},
    );
    final data = jsonDecode(response.body);
    expect(data['token'] != null, true);
  });

  test('get current user', () async {
    final loginResponse = await http.post(
        Uri.parse('http://localhost:3000/users/login'),
        body: {'email': 'test@email.com', 'password': 'password'});
    final loginData = jsonDecode(loginResponse.body);
    final token = loginData['token'];
    final response = await http.get(
        Uri.parse('http://localhost:3000/users/currentUser'),
        headers: {'Authorization': 'Bearer $token'});
    print('loginData: $loginData');
    expect(response.statusCode, 200);
  });
}
