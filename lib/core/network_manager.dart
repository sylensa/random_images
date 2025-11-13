import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:random_images/utils/pretty_logger.dart';
import 'package:random_images/utils/shared_preferance_util.dart';


class NetworkManager {
  NetworkManager._internal();

  static NetworkManager _instance = NetworkManager._internal();

  static NetworkManager get instance => _instance;

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${SharedPreferencesUtils.accessToken}',
  };

  Future<http.Response?> request(NetworkRequestType requestType,
      {required String endpoint,
      dynamic body,
    }) async {
    Exception? exception;

    http.Response? response;
    Uri? uri;
    if (headers.containsKey('Authorization')) {
      headers['Authorization'] = 'Bearer ${SharedPreferencesUtils.accessToken}';
    }
    uri = Uri.parse(
      endpoint,
    );

    // Log the request with pretty formatting
    ApiLogger.logRequest(uri.toString(), headers: headers, body: body);


    try {
      log('response.body1:}');
      if (requestType == NetworkRequestType.get) {
        response = await http.get(uri, headers: headers);
      } else if (requestType == NetworkRequestType.post) {
        response = await http.post(
          uri,
          headers: headers,
          body: json.encode(body),
          // body: body as Map,
          // body: body,
        );
      } else if (requestType == NetworkRequestType.put) {
        response = await http.put(
          uri,
          headers: headers,
          body: json.encode(body),
        );
      } else if (requestType == NetworkRequestType.patch) {
        response =
            await http.patch(uri, headers: headers, body: json.encode(body));
      } else if (requestType == NetworkRequestType.delete) {
        response =
            await http.delete(uri, headers: headers, body: json.encode(body));
      }

    } on TimeoutException catch (e) {
      response = http.Response("Time-out", -1,);
    } on SocketException catch (e) {
      response = http.Response("Check Internet Connection", -2,);
    } on Exception catch (e) {
      response = http.Response("Something went wrong", -3,);
    }
    // Log the response with pretty formatting
    if (response?.body != null) {
      try {
        final responseBody = jsonDecode(response!.body);
        ApiLogger.logResponse(response?.statusCode, body: responseBody);
      } catch (e) {
        // If response is not JSON, log as-is
        ApiLogger.logResponse(response?.statusCode, body: response?.body);
      }
    } else {
      log("Status code: ${response?.statusCode}");
    }

    switch (response?.statusCode) {
      case 401:
        break;
      case 400:
        break;
      case 504:
        break;
      case 403:
        break;
      case 404:
        break;
      case 429:
        break;
      case 500:
        break;
      case 405:
        break;
    }

    return response;
  }

}

enum NetworkRequestType {
  get,
  post,
  put,
  patch,
  delete,
  multipart,
}
