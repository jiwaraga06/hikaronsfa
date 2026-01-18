import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Design/modelDesign.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';

part 'get_design_state.dart';

class GetDesignCubit extends Cubit<GetDesignState> {
  final RepositoryOrder? repository;
  GetDesignCubit({this.repository}) : super(GetDesignInitial());

  void getDesign(context) async {
    emit(GetDesignLoading());
    final response = await repository!.getDsign(context);
    if (response == null) {
      emit(GetDesignFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(GetDesignLoaded(statusCode: statusCode, modelDesign: modelDesignfromJson(jsonEncode(json['data']))));
    } else {
      emit(GetDesignFailed(statusCode: statusCode, json: json));
    }
  }
}
