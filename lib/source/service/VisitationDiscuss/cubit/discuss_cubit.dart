import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/model/VisitDiscuss/modelEntryDiscuss.dart';
import 'package:meta/meta.dart';

part 'discuss_state.dart';

class DiscussCubit extends Cubit<DiscussState> {
  DiscussCubit() : super(DiscussInitial());
  void loadData() {
    emit(DiscussLoaded(model: List.from(modelEntryDiscuss)));
  }

  void clearData() {
    modelEntryDiscuss.clear();
  }

  void addAllData(String visitationdRemarks, String visitationd_VisitationOid, String visitationOid) {
    
    modelEntryDiscuss.add(ModelEntryDiscuss(visitationdVisitationOid: visitationd_VisitationOid, visitationdOid: visitationOid, visitationdRemarks: visitationdRemarks));
    emit(DiscussLoaded(model: List.from(modelEntryDiscuss)));
  }

  void addData(String visitationdRemarks) {
    modelEntryDiscuss.add(
      ModelEntryDiscuss(visitationdVisitationOid: visitationd_VisitationOid, visitationdOid: visitationOidBaru, visitationdRemarks: visitationdRemarks),
    );
    emit(DiscussLoaded(model: List.from(modelEntryDiscuss)));
  }

  void editData(String visitationdOid, String visitationdRemarks) {
    final find = modelEntryDiscuss.indexWhere((e) => e.visitationdOid == visitationdOid);
    if (find != -1) {
      modelEntryDiscuss[find] = modelEntryDiscuss[find].copyWith(visitationdRemarks: visitationdRemarks, visitationdOid: visitationd_VisitationOid);
      emit(DiscussLoaded(model: List.from(modelEntryDiscuss)));
    }
  }

  void deleteData(String visitationdOid) {
    modelEntryDiscuss.removeWhere((e) => e.visitationdOid == visitationdOid);
    emit(DiscussLoaded(model: List.from(modelEntryDiscuss)));
  }
}
