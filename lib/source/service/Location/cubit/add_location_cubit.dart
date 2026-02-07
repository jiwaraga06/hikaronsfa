import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/repository/RepositoryLocation.dart';
import 'package:meta/meta.dart';

part 'add_location_state.dart';

class AddLocationCubit extends Cubit<AddLocationState> {
  final RepositoryLocation? repository;
  AddLocationCubit({this.repository}) : super(AddLocationInitial());

  void addLocation({int? customerId, double? latitude, double? longitude, bool? isManual, String? desc, BuildContext? context}) async {
    var body = {"manualMode": isManual, "confl_cust_id": customerId, "confl_latitude_longitude": "$latitude, $longitude", "confl_location_desc": "$desc"};
    print(body);
    emit(AddLocationLoading());
    repository!.addLocation(body, context).then((value) {
      var json = value.data;
      var statusCode = value.statusCode;
      print("JSON ADD LOCATION:  $json");
      if (statusCode == 200) {
        emit(AddLocationLoaded(statusCode: statusCode, json: json));
      } else {
        emit(AddLocationFailed(statusCode: statusCode, json: json));
      }
    });
  }
}
