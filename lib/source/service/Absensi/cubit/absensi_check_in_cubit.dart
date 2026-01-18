import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hikaronsfa/Widget/customDialog.dart';
import 'package:hikaronsfa/source/env/address.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/env/formatDate.dart';
import 'package:hikaronsfa/source/env/formatTime.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'absensi_check_in_state.dart';

class AbsensiCheckInCubit extends Cubit<AbsensiCheckInState> {
  final RepositoryAbsensi? repository;
  AbsensiCheckInCubit({this.repository}) : super(AbsensiCheckInInitial());

  void prosesCheckIn(customerid, customername, noncustomername, customerType, latitudePlace, longitudePlace, XFile? imageFile, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    var user_name = pref.getString("user_name");
    var user_as_sales_id = pref.getString("user_as_sales_id");
    var tanggal = formatDate(DateTime.now());
    var jam = formatDateToTime(DateTime.now());
    emit(AbsensiCheckInLoading());
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    var alamat = await getFullAddress(latitude: position.latitude, longitude: position.longitude);
    var uuid = Uuid();
    var uniqueID = uuid.v4();
    // HITUNG JARAK
    var convertImg = await File(imageFile!.path).readAsBytes();
    if (customerType == "C") {
      num distanceInMeters = Geolocator.distanceBetween(position.latitude, position.longitude, latitudePlace, longitudePlace);
      // EasyLoading.showInfo("aman : $distanceInMeters");
      var body = FormData.fromMap({
        "attnd_oid": "$uniqueID",
        "attnd_type": "$customerType",
        "attnd_sales_id": "$user_as_sales_id",
        "attnd_cust_id": "$customerid",
        "attnd_cust_name": "$customername",
        "attnd_date_in": "$tanggal",
        "attnd_time_in": "$jam",
        "attnd_latitude_in": "${position.latitude}",
        "attnd_longitude_in": "${position.longitude}",
        "attnd_image_in": await MultipartFile.fromFile(imageFile!.path, filename: imageFile.name),
        // "attnd_image_in": " ${imageFile!.path.split('/').last}",
        // "attnd_image_in": " ${base64Encode(convertImg)}",
        // "attnd_image_in": "SAMPLE_GAMBAR.jpg",
        "attnd_loc_desc_in": "$alamat",
        "attnd_current_status": "IN",
      });
      print(body.files);
      if (distanceInMeters < 100000) {
        repository!.checkIN(body, context).then((value) {
          var json = value.data;
          var statusCode = value.statusCode;
          print("\n CHECK IN :$json");
          if (statusCode == 200) {
            emit(AbsensiCheckInLoaded(statusCode: statusCode, json: json));
          } else {
            emit(AbsensiCheckInFailed(statusCode: statusCode, json: json));
          }
        });
      } else if (distanceInMeters > 1000) {
        emit(AbsensiCheckInFailed(statusCode: 0, json: {"message": "Anda berada jauh dari radius : ${distanceInMeters.toStringAsFixed(2)} M"}));
        // MyDialog.dialogAlert2(context, "Anda berada jauh dari radius : ${distanceInMeters.toStringAsFixed(2)} M");
        // EasyLoading.showInfo("tidak : $distanceInMeters");
      }
    } else if (customerType == "N") {
      // EasyLoading.showInfo("aman : $distanceInMeters");
      var body = FormData.fromMap({
        "attnd_oid": "$uniqueID",
        "attnd_type": "$customerType",
        "attnd_sales_id": "$user_as_sales_id",
        "attnd_cust_id": "0",
        "attnd_cust_name": "$noncustomername",
        "attnd_date_in": "$tanggal",
        "attnd_time_in": "$jam",
        "attnd_latitude_in": "${position.latitude}",
        "attnd_longitude_in": "${position.longitude}",
        "attnd_image_in": await MultipartFile.fromFile(imageFile!.path, filename: imageFile.name),
        // "attnd_image_in": "SAMPLE_GAMBAR.jpg",
        "attnd_loc_desc_in": "$alamat",
        "attnd_current_status": "IN",
      });
      // print(jsonEncode(body));
      repository!.checkIN(body, context).then((value) {
        var json = value.data;
        var statusCode = value.statusCode;
        print("\n CHECK IN :$json");
        if (statusCode == 200) {
          emit(AbsensiCheckInLoaded(statusCode: statusCode, json: json));
        } else {
          emit(AbsensiCheckInFailed(statusCode: statusCode, json: json));
        }
      });
    }
  }
}
