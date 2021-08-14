import 'package:http/http.dart' as http;

class Http {
  Future get(
    String url,
    token,
    contentType,
  ) async {
    Map<String, String> headers = {
      'Content-Type': '$contentType',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }

  Future post(body, String url, token, contentType) async {
    Map<String, String> headers = {
      'Content-Type': '$contentType',
      'Authorization': 'Bearer $token'
    };
    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    print("Response code:${response.statusCode}");
    return response;
  }

  Future delete(body, String url, token, contentType) async {
    Map<String, String> headers = {
      'Content-Type': '$contentType',
      'Authorization': 'Bearer $token'
    };
    final response =
        await http.delete(Uri.parse(url), body: body, headers: headers);
    print("Response code:${response.statusCode}");
    return response;
  }

  Future update(body, String url, token, contentType) async {
    Map<String, String> headers = {
      'Content-Type': '$contentType',
      'Authorization': 'Bearer $token'
    };
    final response =
        await http.put(Uri.parse(url), body: body, headers: headers);
    print("Response code:${response.statusCode}");
    return response;
  }

  Future put(String url, token, params) async {
    final headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };

    final response =
        await http.put(Uri.parse(url), headers: headers, body: params);
    print("Status Code:${response.statusCode}");
    return response;
  }

  logout(body, String url, token, contentType){
    Map<String, String> headers = {
      'Content-Type': '$contentType',
      'Authorization': 'Bearer $token'
    };
    http.post(Uri.parse(url), body: body, headers: headers);
  }
}

class ContentType {
  static const urlEncode = 'application/x-www-form-urlencoded';
  static const json = 'application/json';
}
