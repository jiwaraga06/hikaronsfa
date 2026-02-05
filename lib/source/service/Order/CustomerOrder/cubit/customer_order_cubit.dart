import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Customer/modelCustomerOrder.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'customer_order_state.dart';

class CustomerOrderCubit extends Cubit<CustomerOrderState> {
  final RepositoryOrder? repository;
  CustomerOrderCubit({this.repository}) : super(CustomerOrderInitial());

  void getCustomerOrder(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesid = pref.getString("user_as_sales_id");
    emit(CustomerOrderLoading());
    final response = await repository!.getCustomerOrder(salesid, context);
    if (response == null) {
      emit(CustomerOrderFailed(statusCode: 500, message: "No Response"));
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    if (statusCode == 200) {
      emit(CustomerOrderLoaded(statusCode: statusCode, message: json['message'], model: modelCustomerOrderfromJson(jsonEncode(json['data']))));
    } else {
      emit(CustomerOrderFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
