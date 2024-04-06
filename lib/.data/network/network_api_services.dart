import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'base_api_services.dart';
import 'package:http/http.dart' as http;
import '../app_exceptions.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      if (kDebugMode) {
        print("\n /////////////////////////////////////////////// NetworkApiServices Printing ////////////////////////// \n ");
        print("Passed url: $url");
        print("Returned statusCode: ${response.statusCode} \n");
        print(response.body);
        print("\n /////////////////////////////////////////////// NetworkApiServices Printing ////////////////////////// \n ");
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
        print("\n /////////////////////////////////////////////// NetworkApiServices Printing ////////////////////////// \n ");
        print("Passed url: $url");
        print("Passed data: $data \n ");
        print("Returned statusCode: ${response.statusCode} \n");
        print(response.body);
        print("\n /////////////////////////////////////////////// NetworkApiServices Printed ////////////////////////// \n ");
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
