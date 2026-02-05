import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';

part 'deleteorder_state.dart';

class DeleteorderCubit extends Cubit<DeleteorderState> {
  final RepositoryOrder? repository;
  DeleteorderCubit({this.repository}) : super(DeleteorderInitial());

  void deleteOrder(oid, context) async {
    var body = {"order_oid": oid};
    print(body);
    emit(DeleteorderLoading());
    var response = await repository!.deleteOrder(body, context);
    if (response == null) {
      emit(DeleteorderFailed(statusCode: 500, message: "No Response"));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    if (statusCode == 200) {
      emit(DeleteorderLoaded(statusCode: statusCode, message: json['message']));
    } else {
      emit(DeleteorderFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
