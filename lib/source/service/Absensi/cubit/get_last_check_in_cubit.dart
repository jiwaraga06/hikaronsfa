import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/model/Absensi/modelLastCheckIn.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_last_check_in_state.dart';

class GetLastCheckInCubit extends Cubit<GetLastCheckInState> {
  final RepositoryAbsensi? repository;
  GetLastCheckInCubit({this.repository}) : super(GetLastCheckInInitial());

  void getLastCheckIn(type, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var salesid = pref.getString("user_as_sales_id");

    emit(GetLastCheckInLoading());

    repository!
        .lastCheckIn(salesid, type, context)
        .then((value) {
          final json = value.data;
          final statusCode = value.statusCode;

          // print("GET LAST CHECK IN : $json");

          if (statusCode == 200) {
            final data = json?['data'];

            if (data == null) {
              // data kosong tapi request sukses
              emit(GetLastCheckInLoaded(statusCode: statusCode, model: null));
            } else {
              emit(GetLastCheckInLoaded(statusCode: statusCode, model: modelLastCheckInFromJson(jsonEncode(data))));
            }
          } else {
            emit(GetLastCheckInFailed(statusCode: statusCode, json: json));
          }
        })
        .catchError((e) {
          emit(GetLastCheckInFailed(statusCode: 500, json: {'message': e.toString()}));
        });
  }
}
