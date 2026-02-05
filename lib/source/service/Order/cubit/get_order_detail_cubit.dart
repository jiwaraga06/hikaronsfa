import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Order/modelOrderDetail.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_order_detail_state.dart';

class GetOrderDetailCubit extends Cubit<GetOrderDetailState> {
  final RepositoryOrder? repository;
  GetOrderDetailCubit({this.repository}) : super(GetOrderDetailInitial());

  void getOrderDetail(oid, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesId = pref.getString("user_as_sales_id");
    emit(GetOrderDetailLoading());
    final response = await repository!.getOrderDetail(oid, salesId, context);
    if (response == null) {
      emit(GetOrderDetailFailed(statusCode: 500, message: "NO Response", json: null));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(GetOrderDetailLoaded(statusCode: statusCode, modelOrderDetail: modelOrderDetailFromJson(jsonEncode(json['data']))));
    } else {
      emit(GetOrderDetailFailed(statusCode: statusCode, message: json['message'], json: json));
    }
  }
}
