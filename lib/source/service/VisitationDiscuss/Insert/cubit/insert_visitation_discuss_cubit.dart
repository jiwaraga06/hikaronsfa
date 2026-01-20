import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitDiscuss.dart';
import 'package:meta/meta.dart';

part 'insert_visitation_discuss_state.dart';

class InsertVisitationDiscussCubit extends Cubit<InsertVisitationDiscussState> {
  final RepositoryVisitDiscuss? repository;
  InsertVisitationDiscussCubit({this.repository}) : super(InsertVisitationDiscussInitial());

  void insertDiscuss(context) async {
    var body = {"model": modelEntryDiscuss};
    print("\n\n DISCUSS : ${body['model']}");
    emit(InsertVisitationDiscussLoading());
    final response = await repository!.addVisitDiscuss(jsonEncode(body['model']), context);
    if (response == null) {
      emit(InsertVisitationDiscussFailed(statusCode: 500, json: {"message": "No Response"}));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    print("\nDISKUSI : $json");
    if (statusCode == 200) {
      emit(InsertVisitationDiscussLoaded(statusCode: statusCode, json: json));
    } else {
      emit(InsertVisitationDiscussFailed(statusCode: 500, json: json));
    }
  }
}
