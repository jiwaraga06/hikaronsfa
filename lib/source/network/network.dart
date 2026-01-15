import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Response?> network({required String method, required String url, dynamic body, context}) async {
  final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 20), receiveTimeout: const Duration(seconds: 20)));

  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');

  var headers = {
    'Authorization': 'Bearer $token',
    // 'Accept': 'application/json'
  };

  try {
    late Response response;

    if (method == "GET") {
      response = await dio.get(url, options: Options(headers: headers));
    } else if (method == "POST") {
      response = await dio.post(url, data: body, options: Options(headers: headers));
    } else if (method == "PUT") {
      response = await dio.put(url, data: body, options: Options(headers: headers));
    } else if (method == "DELETE") {
      response = await dio.delete(url, data: body, options: Options(headers: headers));
    } else {
      throw Exception("Method not supported");
    }

    return response;
  } on DioException catch (e) {
    EasyLoading.dismiss();

    return Response(
      requestOptions: RequestOptions(path: url),
      statusCode: e.response?.statusCode ?? 500,
      data: {"message": e.response?.data?['message'] ?? e.message ?? "Terjadi kesalahan jaringan"},
    );
  } on SocketException {
    EasyLoading.dismiss();
    return Response(requestOptions: RequestOptions(path: url), statusCode: 503, data: {"message": "Tidak ada koneksi internet"});
  } on TimeoutException {
    EasyLoading.dismiss();
    return Response(requestOptions: RequestOptions(path: url), statusCode: 408, data: {"message": "Koneksi timeout"});
  } catch (e) {
    EasyLoading.dismiss();
    return Response(requestOptions: RequestOptions(path: url), statusCode: 500, data: {"message": e.toString()});
  }
}
