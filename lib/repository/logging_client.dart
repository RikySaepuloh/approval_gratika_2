import 'package:approval_gratika/shared_preferences_utils.dart';
import 'package:http/http.dart' as http;

class LoggingClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await SharedPreferencesUtils.getLoginToken();

    if (token == null) {
      throw Exception('Authorization token not available');
    }

    request.headers['Authorization'] = 'Bearer $token';

    print('Sending ${request.method} request to ${request.url}');
    request.headers.forEach((name, value) {
      print('$name: $value');
    });
    if (request is http.Request && request.body != null) {
      print(request.body);
    }

    final response = await _inner.send(request);

    print('Received ${response.statusCode} response from ${response.request?.url}');
    response.headers.forEach((name, values) {
      // values.forEach((value) {
      //   print('$name: $value');
      // });
    });

    return response;
  }
}
