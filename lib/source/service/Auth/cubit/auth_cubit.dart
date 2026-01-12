import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hikaronsfa/Widget/customDialog.dart';
import 'package:hikaronsfa/source/repository/RepositoryAuth.dart';
import 'package:hikaronsfa/source/router/string.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  RepositoryAuth? repository;
  AuthCubit({this.repository}) : super(AuthInitial());

  void getSession(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString('username');
    if (username != null) {
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(context, dashboardScreen, (Route<dynamic> route) => false);
    } else {
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(context, loginScreen, (Route<dynamic> route) => false);
    }
  }

  void logout(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushNamedAndRemoveUntil(context, loginScreen, (Route<dynamic> route) => false);
  }

  void getProfile(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString('username');
    emit(AuthLoading());
    if (username != null) {
      emit(AuthProfile(username: username));
    }
  }

  void login(String username, String password, BuildContext context) async {
    var body = {"username": username, "password": password};
    SharedPreferences pref = await SharedPreferences.getInstance();
    emit(AuthLoading());

    repository!.login(body, context).then((value) async {
      var json = value.data;
      var statusCode = value.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        pref.setString("user_id", json['data']['user_id'].toString());
        pref.setString("username", json['data']['user_name']);
        pref.setString("user_as_sales_id", json['data']['user_as_sales_id'].toString());

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(context, dashboardScreen, (Route<dynamic> route) => false);
        emit(AuthLoaded(statusCode: statusCode, json: json));
      } else {
        emit(AuthFailed(statusCode: statusCode, json: json));
      }
      print("login: \n$json");
    });
  }
}
