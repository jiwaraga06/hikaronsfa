import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'updateorder_state.dart';

class UpdateorderCubit extends Cubit<UpdateorderState> {
  final RepositoryOrder? repository;
  UpdateorderCubit({this.repository}) : super(UpdateorderInitial());

  void updateOrder(customerid, tanggal, po, remark, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString("username");
    var salesid = pref.getString("user_as_sales_id");
    var body = {
      "order_oid": oid_uuid,
      "customer_id": customerid,
      "date": tanggal,
      "po": po,
      "remark": remark,
      "user_name": username,
      "sales_id": salesid,
      "detail": modelEntryOrderDetail,
    };
    print(body);
    emit(UpdateorderLoading());
    var response = await repository!.updateOrder(body, context);
    if (response == null) {
      emit(UpdateorderFailed(statusCode: 500, message: "No Response"));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    if (statusCode == 200) {
      emit(UpdateorderLoaded(statusCode: statusCode, message: json['message'], json: json));
    } else {
      emit(UpdateorderFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
