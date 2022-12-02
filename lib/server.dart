import 'package:alfred/alfred.dart';

class Server {
  final app = Alfred();

  Future<void> start() async {
    app.get('/me', (HttpRequest req, HttpResponse res) {
      final date = req.headers.date;
      return {'date': date?.toIso8601String() ?? 'no date'};
    });

    await app.listen();
  }
}
