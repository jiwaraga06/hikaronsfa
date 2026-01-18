import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Customer/modelCustomerVisitation.dart';
import 'package:hikaronsfa/source/repository/repositoryCustomer.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_customer_visitation_state.dart';

class GetCustomerVisitationCubit extends Cubit<GetCustomerVisitationState> {
  final RepositoryCustomer? repository;
  GetCustomerVisitationCubit({this.repository}) : super(GetCustomerVisitationInitial());

  void getCustomerVisitation(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesId = pref.getString("user_as_sales_id");
    emit(GetCustomerVisitationLoading());
    final response = await repository!.getCustomerVisitation(salesId, context);
    if (response == null) {
      emit(GetCustomerVisitationFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(GetCustomerVisitationLoaded(statusCode: statusCode, model: modelCustomerVisitationfromJson(jsonEncode(json['data']))));
    } else {
      emit(GetCustomerVisitationFailed(statusCode: statusCode, json: json));
    }
  }
}
