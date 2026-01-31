import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Customer/modelCustomer.dart';
import 'package:hikaronsfa/source/repository/repositoryCustomer.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_customer_state.dart';

class GetCustomerCubit extends Cubit<GetCustomerState> {
  final RepositoryCustomer? repository;
  GetCustomerCubit({this.repository}) : super(GetCustomerInitial());

  void getLocationCustomer(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_as_sales_id = pref.getString("user_as_sales_id");
    emit(GetCustomerLoading());
    repository!.getLocationCustomer(user_as_sales_id, context).then((value) {
      var json = value.data;
      var statusCode = value.statusCode;
      print("\n $json \n");
      if (statusCode == 200) {
        emit(GetCustomerLoaded(statusCode: statusCode, model: modelCustomerfromJson(jsonEncode(json['data']))));
      } else {
        emit(GetCustomerFailed(statusCode: statusCode, json: json));
      }
    });
  }

  void getCustomerAll(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_as_sales_id = pref.getString("user_as_sales_id");
    emit(GetCustomerLoading());
    repository!.getAllCustomer(user_as_sales_id, context).then((value) {
      var json = value.data;
      var statusCode = value.statusCode;
      print("\n $json \n");
      if (statusCode == 200) {
        emit(GetCustomerLoaded(statusCode: statusCode, model: modelCustomerfromJson(jsonEncode(json['data']))));
      } else {
        emit(GetCustomerFailed(statusCode: statusCode, json: json));
      }
    });
  }

  void getCustomerOutstanding(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_as_sales_id = pref.getString("user_as_sales_id");
    emit(GetCustomerLoading());
    repository!.getCustomerOutstanding(user_as_sales_id, context).then((value) {
      var json = value.data;
      var statusCode = value.statusCode;
      // print("\n $json \n");
      if (statusCode == 200) {
        emit(GetCustomerLoaded(statusCode: statusCode, model: modelCustomerfromJson(jsonEncode(json['data']))));
      } else {
        emit(GetCustomerFailed(statusCode: statusCode, json: json));
      }
    });
  }
}
