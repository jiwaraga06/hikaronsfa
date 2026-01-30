import 'package:bloc/bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_radius_state.dart';

class GetRadiusCubit extends Cubit<GetRadiusState> {
  final RepositoryAbsensi? repository;
  GetRadiusCubit({this.repository}) : super(GetRadiusInitial());
  void getRadius(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await repository!.radius(context);
    if (response == null) {
      EasyLoading.showError("Failed Get Radius", duration: Duration(seconds: 1));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    // print("RADIUS $json");
    if (statusCode == 200) {
      pref.setString("radius", json['data'][0]['value'].toString());
    } else {
      // EasyLoading.showError("Pro", duration: Duration(seconds: 1));
    }
  }
}
