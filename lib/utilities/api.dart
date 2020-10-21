import 'dart:convert';
import 'package:couchya/api/auth.dart';
import 'package:couchya/app_config.dart';
import 'package:couchya/utilities/api_response.dart';
import 'package:couchya/utilities/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CallApi {
  static Future<ApiResponse> post(path, data) async {
    Uri fullUrl = Uri.http(AppConfig.API_URL, '/api/' + path);
    print(fullUrl);
    var response = await http.post(fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders(await LocalStorage.getToken()));

    print(json.decode(response.body));

    return sendResponse(response);
  }

  static Future<ApiResponse> get(path, [queryParams]) async {
    if (queryParams == null) queryParams = {};
    String fullUrl = 'http://' +
        AppConfig.API_URL +
        '/api/' +
        path +
        '?' +
        getQueryString(queryParams);
    print(fullUrl);
    var response = await http.get(fullUrl,
        headers: _setHeaders(await LocalStorage.getToken()));
    print(json.decode(response.body));
    return sendResponse(response);
  }

  static _setHeaders(token) {
    return {
      'Authorization': 'Bearer ' + token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static ApiResponse sendResponse(response) {
    var decoded = json.decode(response.body);
    ApiResponse apiResponse = new ApiResponse();
    apiResponse.setMessage(decoded['message']);
    if (response.statusCode == 200 && decoded['success'] == true) {
      apiResponse.setSuccess(true);
      apiResponse.setData(decoded);
      return apiResponse;
    } else if (response.statusCode == 401) {
      Auth.logout();
    }
    ;
    apiResponse.setErrors(decoded['data']);
    return apiResponse;
  }
}

String getQueryString(Map params,
    {String prefix: '&', bool inRecursion: false}) {
  String query = '';

  params.forEach((key, value) {
    if (inRecursion) {
      key = '[$key]';
    }

    if (value is String || value is int || value is double || value is bool) {
      query += '$prefix$key=$value';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
      });
    }
  });

  return query;
}
