import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'delete_visitation_state.dart';

class DeleteVisitationCubit extends Cubit<DeleteVisitationState> {
  final RepositoryVisitation? repository;
  DeleteVisitationCubit({this.repository}) : super(DeleteVisitationInitial());

  void deleteVisitation(visitationOid, attndOid, context) async {
    var body = {"attnd_oid": "$attndOid", "visitationOid": "$visitationOid"};
    print(body);
    emit(DeleteVisitationLoading());
    final response = await repository!.deleteVisitation(body, context);
    if (response == null) {
      emit(DeleteVisitationFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }
    var statusCode = response.statusCode ?? 500;
    var json = response.data;
    print(json);
    if (statusCode == 200) {
      emit(DeleteVisitationLoaded(statusCode: statusCode, json: json));
    } else {
      emit(DeleteVisitationFailed(statusCode: statusCode, json: json));
    }
  }
}
