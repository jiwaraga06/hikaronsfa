import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitPic.dart';
import 'package:meta/meta.dart';

part 'update_visitation_pic_state.dart';

class UpdateVisitationPicCubit extends Cubit<UpdateVisitationPicState> {
  final RepositoryVisitPic? repository;
  UpdateVisitationPicCubit({this.repository}) : super(UpdateVisitationPicInitial());
  void updatepic(context) async {
    var body = {"model": modelEntryPIC};
    print("\n\n PIC : ${body['model']}");
    final response = await repository!.editVisitPic(jsonEncode(body['model']), context);
    emit(UpdateVisitationPicLoading());
    if (response == null) {
      emit(UpdateVisitationPicFailed(statusCode: 500, json: {"message": "No Response"}));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    if (statusCode == 200) {
      emit(UpdateVisitationPicLoaded(statusCode: statusCode, json: json));
    } else {
      emit(UpdateVisitationPicFailed(statusCode: 500, json: json));
    }
  }
}
