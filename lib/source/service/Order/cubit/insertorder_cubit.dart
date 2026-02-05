import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'insertorder_state.dart';

class InsertorderCubit extends Cubit<InsertorderState> {
  final RepositoryOrder? repository;
  InsertorderCubit({this.repository}) : super(InsertorderInitial());

  void insertOrder(customerid, tanggal, po, remark, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString("username");
    var salesid = pref.getString("user_as_sales_id");
    var body = {
      "customer_id": customerid,
      "date": tanggal,
      "po": po,
      "remark": remark,
      "user_name": username,
      "sales_id": salesid,
      "detail": modelEntryOrderDetail,
    };
    print(body);
    emit(InsertorderLoading());
    var response = await repository!.insertOrder(body, context);
    if (response == null) {
      emit(InsertorderFailed(statusCode: 500, message: "No Response"));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    if (statusCode == 200) {
      emit(InsertorderLoaded(statusCode: statusCode, message: json['message'], json: json));
    } else {
      emit(InsertorderFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
