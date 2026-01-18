import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Visitation/modelVisitation.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_visitation_state.dart';

class GetVisitationCubit extends Cubit<GetVisitationState> {
  final RepositoryVisitation? repository;
  GetVisitationCubit({this.repository}) : super(GetVisitationInitial());

  void getVisitation(startdate, enddate, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesId = pref.getString("user_as_sales_id");
    emit(GetVisitationLoading());
    final response = await repository!.getVisitation(salesId, startdate, enddate, context);
    if (response == null) {
      emit(GetVisitationFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(GetVisitationLoaded(statusCode: statusCode, modelVisitation: modelVisitationfromJson(jsonEncode(json['data']))));
    } else {
      emit(GetVisitationFailed(statusCode: statusCode, json: json));
    }
  }
}
