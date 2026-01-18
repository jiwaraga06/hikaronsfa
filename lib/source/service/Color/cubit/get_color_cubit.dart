import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Color/modelColor.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';

part 'get_color_state.dart';

class GetColorCubit extends Cubit<GetColorState> {
  final RepositoryOrder? repository;
  GetColorCubit({this.repository}) : super(GetColorInitial());

  void getColor(designId, context) async {
    emit(GetColorLoading());
    final response = await repository!.getColorbyDesign(designId, context);
    if (response == null) {
      emit(GetColorFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(GetColorLoaded(statusCode: statusCode, modelColor: modelColorfromJson(jsonEncode(json['data']))));
    } else {
      emit(GetColorFailed(statusCode: statusCode, json: json));
    }
  }
}
