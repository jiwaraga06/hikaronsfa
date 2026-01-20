import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/model/VisitPIC/modelEntryPIC.dart';
import 'package:meta/meta.dart';

part 'pic_state.dart';

class PicCubit extends Cubit<PicState> {
  PicCubit() : super(PicInitial());
  // final List<ModelEntryPIC> model = [];

  void clearData() {
    modelEntryPIC.clear();
  }

  void loadData() {
    emit(PicLoaded(model: List.from(modelEntryPIC)));
  }

  void addAllData(String visitationdRemarks, String visitationdJabatan, String visitationd_VisitationOid, String visitationOid) {
    
    modelEntryPIC.add(
      ModelEntryPIC(
        visitationdVisitationOid: visitationd_VisitationOid,
        visitationdOid: visitationOid,
        visitationdRemarks: visitationdRemarks,
        visitationdJabatan: visitationdJabatan,
      ),
    );
    emit(PicLoaded(model: List.from(modelEntryPIC)));
  }

  void addData(String visitationdRemarks, String visitationdJabatan) {
    modelEntryPIC.add(
      ModelEntryPIC(
        visitationdVisitationOid: visitationd_VisitationOid,
        visitationdOid: visitationOidBaru,
        visitationdRemarks: visitationdRemarks,
        visitationdJabatan: visitationdJabatan,
      ),
    );
    emit(PicLoaded(model: List.from(modelEntryPIC)));
  }

  void editData(String visitationdOid, String visitationdRemarks, String visitationdJabatan) {
    final find = modelEntryPIC.indexWhere((e) => e.visitationdOid == visitationdOid);
    if (find != -1) {
      modelEntryPIC[find] = modelEntryPIC[find].copyWith(
        visitationdJabatan: visitationdJabatan,
        visitationdRemarks: visitationdRemarks,
        visitationdOid: visitationd_VisitationOid,
      );
      emit(PicLoaded(model: List.from(modelEntryPIC)));
    }
  }

  void deleteData(String visitationdOid) {
    modelEntryPIC.removeWhere((e) => e.visitationdOid == visitationdOid);
    emit(PicLoaded(model: List.from(modelEntryPIC)));
  }
}
