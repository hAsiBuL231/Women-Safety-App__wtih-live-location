import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'base_api_services.dart';
import 'package:http/http.dart' as http;
import '../app_exceptions.dart';
import '../../.utils/Functions.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      if (kDebugMode) {
        print("\n /////////////////////////////////////////////// NetworkApiServices GetApi Printing ////////////////////////// \n ");
        print("Passed url: $url");
        print("Returned statusCode: ${response.statusCode} \n");
        print(response.body);
        print("\n /////////////////////////////////////////////// NetworkApiServices GetApi Printing ////////////////////////// \n ");
      }
      return returnResponse(response);
    } catch (e) {
      // Handle any errors that occur during the HTTP request
      if (e is SocketException) {
        throw InternetExceptions('No internet connection');
      } else if (e is RequestTimeOut) {
        throw RequestTimeOut('Request timed out');
      } else {
        // Handle other exceptions
        throw Exception('Failed to fetch data: $e');
      }
    }
  }

  // Future getApi(String url) async {
  //   /*if (kDebugMode) {
  //     print(" \n \n NetworkApiServices Print  Url :     $url \n \n ");
  //   }*/
  //   dynamic jsonResponse;
  //   try {
  //     final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
  //     jsonResponse = returnResponse(response);
  //   } on SocketException {
  //     throw InternetExceptions('');
  //   } on RequestTimeOut {
  //     throw RequestTimeOut('');
  //   }
  //   if (kDebugMode) {
  //     print("   000 \n \n NetworkApiServices Print  Url :     $url \n ");
  //     print(" NetworkApiServices Print  Response:     ${jsonResponse['documents']} \n \n   111");
  //   }
  //   return jsonResponse;
  // }

  @override
  Future postApi(dynamic data, String url) async {
    dynamic jsonResponse;
    try {
      //final response = await http.post(Uri.parse(url), body: jsonEncode(data)).timeout(Duration(seconds: 10));
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: 10));

      if (kDebugMode) {
        print("\n /////////////////////////////////////////////// NetworkApiServices PostApi Printing ////////////////////////// \n ");
        print("Passed url: $url");
        print("Passed data: $data \n ");
        print("Returned statusCode: ${response.statusCode} \n");
        print(response.body);
        print("\n /////////////////////////////////////////////// NetworkApiServices PostApi Printed ////////////////////////// \n ");
      }
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetExceptions('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return jsonResponse;
  }

  @override
  Future putApi(dynamic data, String url) async {
    dynamic jsonResponse;
    try {
      //final response = await http.post(Uri.parse(url), body: jsonEncode(data)).timeout(Duration(seconds: 10));
      final response = await http.put(
        Uri.parse(url),
        body: data,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: 10));

      if (kDebugMode) {
        print("\n /////////////////////////////////////////////// NetworkApiServices PutApi Printing ////////////////////////// \n ");
        print("Passed url: $url");
        print("Passed data: $data \n ");
        print("Returned statusCode: ${response.statusCode} \n");
        print(response.body);
        print("\n /////////////////////////////////////////////// NetworkApiServices PutApi Printed ////////////////////////// \n ");
      }
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetExceptions('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return jsonResponse;
  }

  @override
  Future patchApi(String url, dynamic data) async {
    dynamic jsonResponse;
    try {
      //final response = await http.post(Uri.parse(url), body: jsonEncode(data)).timeout(Duration(seconds: 10));
      final response = await http.patch(
        Uri.parse(url),
        body: data,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(Duration(seconds: 10));

      if (kDebugMode) {
        print("\n /////////////////////////////////////////////// NetworkApiServices PatchApi Printing ////////////////////////// \n ");
        print("Passed url: $url");
        print("Passed data: $data \n ");
        print("Returned statusCode: ${response.statusCode} \n");
        print(response.body);
        print("\n /////////////////////////////////////////////// NetworkApiServices PatchApi Printed ////////////////////////// \n ");
      }
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetExceptions('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return jsonResponse;
  }

  @override
  Future deleteApi(dynamic data, String url) async {
    dynamic jsonResponse;
    try {
      //final response = await http.post(Uri.parse(url), body: jsonEncode(data)).timeout(Duration(seconds: 10));
      final response = await http
          .delete(
            Uri.parse(url),
            // body: data,
            // headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
          )
          .timeout(Duration(seconds: 10));

      if (kDebugMode) {
        print("\n /////////////////////////////////////////////// NetworkApiServices DeleteApi Printing ////////////////////////// \n ");
        print("Passed url: $url");
        print("Returned statusCode: ${response.statusCode} \n");
        print(response.body);
        print("\n /////////////////////////////////////////////// NetworkApiServices DeleteApi Printed ////////////////////////// \n ");
      }
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetExceptions('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return jsonResponse;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        // print("response.statusCode,,,, case == 200");
        dynamic responseJson = jsonDecode(response.body);
        showToast("Get Api call successful");
        return responseJson;
      case 201:
        // print("response.statusCode,,,, case == 200");
        dynamic responseJson = jsonDecode(response.body);
        showToast("Post Api call successful");
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        throw FetchDataExceptions("${responseJson['error']['message']}");
      //   throw InvalidUrlExceptions('');
      default:
        throw FetchDataExceptions("Error occurred while communicating with server ${response.statusCode}");
    }
  }
}
