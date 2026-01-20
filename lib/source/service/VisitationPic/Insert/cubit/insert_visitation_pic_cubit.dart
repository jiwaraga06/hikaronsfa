import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitPic.dart';
import 'package:meta/meta.dart';

part 'insert_visitation_pic_state.dart';

class InsertVisitationPicCubit extends Cubit<InsertVisitationPicState> {
  final RepositoryVisitPic? repository;
  InsertVisitationPicCubit({this.repository}) : super(InsertVisitationPicInitial());

  void insertpic(context) async {
    var body = {"model": modelEntryPIC};
    print("\n\n PIC : ${body['model']}");
    final response = await repository!.addVisitPic(jsonEncode(body['model']), context);
    emit(InsertVisitationPicLoading());
    if (response == null) {
      emit(InsertVisitationPicFailed(statusCode: 500, json: {"message": "No Response"}));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
     print("\nPIC : $json");
    if (statusCode == 200) {
      emit(InsertVisitationPicLoaded(statusCode: statusCode, json: json));
    } else {
      emit(InsertVisitationPicFailed(statusCode: 500, json: json));
    }
  }
}
