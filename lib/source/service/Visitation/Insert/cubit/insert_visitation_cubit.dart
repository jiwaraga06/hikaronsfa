import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'insert_visitation_state.dart';

class InsertVisitationCubit extends Cubit<InsertVisitationState> {
  final RepositoryVisitation? repository;
  InsertVisitationCubit({this.repository}) : super(InsertVisitationInitial());

  void insertVisitation(date, customerId, attndOid, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString("username");
    var salesId = pref.getString("user_as_sales_id");
    var body = {"username": "$username", "visitation_date": "$date", "customer_id": "$customerId", "attnd_oid": "$attndOid", "sales_id": "$salesId"};
    print(body);
    emit(InsertVisitationLoading());
    final response = await repository!.insertVisitation(body, context);
    if (response == null) {
      emit(InsertVisitationFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    if (statusCode == 200) {
      emit(InsertVisitationLoaded(statusCode: statusCode, json: json));
    } else {
      emit(InsertVisitationFailed(statusCode: statusCode, json: json));
    }
  }
}
