import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Outstanding/modelOutstanding.dart';
import 'package:hikaronsfa/source/repository/repositoryOutstanding.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'outstanding_shipment_state.dart';

class OutstandingShipmentCubit extends Cubit<OutstandingShipmentState> {
  final RepositoryOutstanding? repository;
  OutstandingShipmentCubit({this.repository}) : super(OutstandingShipmentInitial());

  void getOutstandingShipment(customerid, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesid = pref.getString("user_as_sales_id");
    emit(OutstandingShipmentLoading());
    final response = await repository!.getOutstandingShipment(salesid, customerid, context);
    if (response == null) {
      emit(OutstandingShipmentFailed(statusCode: 500, message: "No Response"));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    if (statusCode == 200) {
      emit(OutstandingShipmentLoaded(statusCode: statusCode, message: json['message'], model: modelOutstandingShipmentfromJson(jsonEncode(json['data']))));
    } else {
      emit(OutstandingShipmentFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
