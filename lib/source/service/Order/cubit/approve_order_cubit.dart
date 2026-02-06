import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';

part 'approve_order_state.dart';

class ApproveOrderCubit extends Cubit<ApproveOrderState> {
  final RepositoryOrder? repository;
  ApproveOrderCubit({this.repository}) : super(ApproveOrderInitial());

  void approveOrder(orderOid, context) async {
    emit(ApproveOrderLoading());
    var body = {"order_oid": orderOid};
    final response = await repository!.approveOrder(body, context);
    if (response == null) {
      emit(ApproveOrderFailed(statusCode: 500, message: "No Response"));
      return;
    }

    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    if (statusCode == 200) {
      emit(ApproveOrderLoaded(statusCode: statusCode, message: json['message']));
    } else {
      emit(ApproveOrderFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
