import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Order/modelOrder.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_order_state.dart';

class GetOrderCubit extends Cubit<GetOrderState> {
  final RepositoryOrder? repository;
  GetOrderCubit({this.repository}) : super(GetOrderInitial());

  void initial() {
    emit(GetOrderInitial());
  }

  void getOrder(startdate, enddate, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesId = pref.getString("user_as_sales_id");
    emit(GetOrderLoading());
    final response = await repository!.getOrder(salesId, startdate, enddate, context);
    if (response == null) {
      emit(GetOrderFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(GetOrderLoaded(statusCode: statusCode, modelOrder: modelOrderfromJson(jsonEncode(json['data']))));
    } else {
      emit(GetOrderFailed(statusCode: statusCode, json: json));
    }
  }
}
