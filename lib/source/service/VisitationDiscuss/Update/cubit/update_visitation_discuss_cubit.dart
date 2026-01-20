import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitDiscuss.dart';
import 'package:meta/meta.dart';

part 'update_visitation_discuss_state.dart';

class UpdateVisitationDiscussCubit extends Cubit<UpdateVisitationDiscussState> {
  final RepositoryVisitDiscuss? repository;
  UpdateVisitationDiscussCubit({this.repository}) : super(UpdateVisitationDiscussInitial());
  void updateDiscuss(context) async {
    var body = {"model": modelEntryDiscuss};
    print("\n\n DISCUSS : ${body['model']}");
    emit(UpdateVisitationDiscussLoading());
    final response = await repository!.editVisitDiscuss(jsonEncode(body['model']), context);
    if (response == null) {
      emit(UpdateVisitationDiscussFailed(statusCode: 500, json: {"message": "No Response"}));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    print("\nDISKUSI : $json");
    if (statusCode == 200) {
      emit(UpdateVisitationDiscussLoaded(statusCode: statusCode, json: json));
    } else {
      emit(UpdateVisitationDiscussFailed(statusCode: 500, json: json));
    }
  }
}
