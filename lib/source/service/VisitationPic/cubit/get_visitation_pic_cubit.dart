import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/model/VisitPIC/modelVisitPIC.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitPic.dart';
import 'package:meta/meta.dart';

part 'get_visitation_pic_state.dart';

class GetVisitationPicCubit extends Cubit<GetVisitationPicState> {
  final RepositoryVisitPic? repository;
  GetVisitationPicCubit({this.repository}) : super(GetVisitationPicInitial());

  void getVisitPic(context) async {
    emit(GetVisitationPicLoading());
    final response = await repository!.getVisitPic(oid_uuid, context);
    if (response == null) {
      emit(GetVisitationPicFailed(statusCode: 500, json: {"message": "No Response"}));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    if (statusCode == 200) {
      emit(GetVisitationPicLoaded(statusCode: statusCode, model: modelVisitPicfromJson(jsonEncode(json['data']))));
    } else {
      emit(GetVisitationPicFailed(statusCode: 500, json: json));
    }
  }
}
