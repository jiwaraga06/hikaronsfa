import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'update_visitation_state.dart';

class UpdateVisitationCubit extends Cubit<UpdateVisitationState> {
  final RepositoryVisitation? repository;
  UpdateVisitationCubit({this.repository}) : super(UpdateVisitationInitial());
  void updateVisitation(date, customerId, attndOid, visitationOid, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString("username");
    var salesId = pref.getString("user_as_sales_id");
    var body = {
      "username": "$username",
      "visitation_date": "$date",
      "customer_id": "$customerId",
      "attndOid": "$attndOid",
      "visitationOid": "$visitationOid",
      "sales_id": "$salesId",
    };
    print("\n $body \n");
    emit(UpdateVisitationLoading());
    final response = await repository!.updateVisitation(body, context);
    if (response == null) {
      emit(UpdateVisitationFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    print(json);
    if (statusCode == 200) {
      emit(UpdateVisitationLoaded(statusCode: statusCode, json: json));
    } else {
      emit(UpdateVisitationFailed(statusCode: statusCode, json: json));
    }
  }
}
