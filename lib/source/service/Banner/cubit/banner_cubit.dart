import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Banner/modelBanner.dart';
import 'package:hikaronsfa/source/repository/RepositoryBanner.dart';
import 'package:meta/meta.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final RepositoryBanner? repository;
  BannerCubit({this.repository}) : super(BannerInitial());

  void getBannner(context) async {
    emit(BannerLoading());
    final response = await repository!.getBanner(context);
    if (response == null) {
      emit(BannerFailed(statusCode: 500, message: "No Response !"));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(BannerLoaded(statusCode: statusCode, message: json['message'], model: modelBannerfromJson(jsonEncode(json['data']))));
    } else {
      emit(BannerFailed(statusCode: 500, message: json['message']));
    }
  }
}
