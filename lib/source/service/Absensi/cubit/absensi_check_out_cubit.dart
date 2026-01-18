import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hikaronsfa/source/env/address.dart';
import 'package:hikaronsfa/source/env/formatDate.dart';
import 'package:hikaronsfa/source/env/formatTime.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'absensi_check_out_state.dart';

class AbsensiCheckOutCubit extends Cubit<AbsensiCheckOutState> {
  final RepositoryAbsensi? repository;
  AbsensiCheckOutCubit({this.repository}) : super(AbsensiCheckOutInitial());

  void prosesCheckOut(oid, imageFile, latitudePlace, longitudePlace, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_as_sales_id = pref.getString("user_as_sales_id");
    var tanggal = formatDate(DateTime.now());
    var jam = formatDateToTime(DateTime.now());
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    num distanceInMeters = Geolocator.distanceBetween(position.latitude, position.longitude, latitudePlace, longitudePlace);
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    var alamat = await getFullAddress(latitude: position.latitude, longitude: position.longitude);
    var convertImg = await File(imageFile.path).readAsBytes();
    var body = FormData.fromMap({
      "attnd_date_out": "$tanggal",
      "attnd_time_out": "$jam",
      "attnd_latitude_out": "${position.latitude}",
      "attnd_longitude_out": "${position.latitude}",
      // "attnd_image_out": "checkout2.jpg",
      // "attnd_image_out": "${imageFile!.path.split('/').last}",
      // "attnd_image_out": "${base64Encode(convertImg)}",
      "attnd_image_out": await MultipartFile.fromFile(imageFile!.path, filename: imageFile.name),
      "attnd_loc_desc_out": "$alamat",
      "attnd_current_status": "OUT",
      "user_as_sales_id": "$user_as_sales_id",
      "attnd_oid": "$oid",
    });
    print(body);
    emit(AbsensiCheckOutLoading());
    final response = await repository!.checkOUT(body, context);

    if (response == null) {
      emit(AbsensiCheckOutFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }

    final statusCode = response.statusCode ?? 500;
    final json = response.data;
    print("\n CHECK OUT : $json");

    if (statusCode == 200 && json != null && json['data'] != null) {
      try {
        emit(AbsensiCheckOutLoaded(statusCode: statusCode, json: json));
      } catch (e) {
        emit(AbsensiCheckOutFailed(statusCode: 500, json: {"message": "Gagal parsing lokasi"}));
      }
    } else {
      emit(AbsensiCheckOutFailed(statusCode: statusCode, json: json ?? {"message": "Unknown error"}));
    }
  }
}
