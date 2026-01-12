import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryLocation.dart';
import 'package:meta/meta.dart';

part 'add_location_state.dart';

class AddLocationCubit extends Cubit<AddLocationState> {
  final RepositoryLocation? repository;
  AddLocationCubit({this.repository}) : super(AddLocationInitial());

  void addLocation(confl_cust_id, latitude, longitude, confl_location_desc, context) async {
    emit(AddLocationLoading());
    var body = {"confl_cust_id": confl_cust_id, "confl_latitude_longitude": "$latitude,$longitude", "confl_location_desc": "$confl_location_desc"};
    print(body);
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
