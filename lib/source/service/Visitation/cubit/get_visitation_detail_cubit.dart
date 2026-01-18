import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Visitation/modelVisitatioDetail.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_visitation_detail_state.dart';

class GetVisitationDetailCubit extends Cubit<GetVisitationDetailState> {
  final RepositoryVisitation? repository;
  GetVisitationDetailCubit({this.repository}) : super(GetVisitationDetailInitial());
  void getVisitationDetail(oid,  context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesId = pref.getString("user_as_sales_id");
    emit(GetVisitationDetailLoading());
    final response = await repository!.getVisitationDetail(salesId, oid, context);
    if (response == null) {
      emit(GetVisitationDetailFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(GetVisitationDetailLoaded(statusCode: statusCode, modelVisitationDetail: modelVisitationDetailFromJson(jsonEncode(json['data']))));
    } else {
      emit(GetVisitationDetailFailed(statusCode: statusCode, json: json));
    }
  }
}
