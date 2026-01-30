import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/model/VisitImage/modelEntryImage.dart';
import 'package:meta/meta.dart';

part 'lampiran_state.dart';

class LampiranCubit extends Cubit<LampiranState> {
  LampiranCubit() : super(LampiranInitial());

  void clearData() {
    modelEntryImage.clear();
    emit(LampiranLoaded(model: List.from(modelEntryImage)));
  }

  void loadData() {
    emit(LampiranLoaded(model: List.from(modelEntryImage)));
  }

  void addAllData({String? visitationdRemarks, dynamic image, String? visitationd_VisitationOid, String? visitationOid}) {
    modelEntryImage.add(
      ModelEntryImage(
        visitationdVisitationOid: visitationd_VisitationOid,
        visitationdOid: visitationOid,
        visitationdRemarks: visitationdRemarks,
        visitationdImages: image,
        
      ),
    );
    emit(LampiranLoaded(model: List.from(modelEntryImage)));
  }

  void addData(String visitationdRemarks, dynamic visitationdImages) {
    modelEntryImage.add(
      ModelEntryImage(
        visitationdVisitationOid: visitationd_VisitationOid,
        visitationdOid: visitationOidBaru,
        visitationdRemarks: visitationdRemarks,
        visitationdImages: visitationdImages,
        
      ),
    );
    emit(LampiranLoaded(model: List.from(modelEntryImage)));
  }

  void editData(String visitationdOid, String visitationdRemarks, dynamic? visitationdImages) {
    final find = modelEntryImage.indexWhere((e) => e.visitationdOid == visitationdOid);

    if (find != -1) {
      modelEntryImage[find] = modelEntryImage[find].copyWith(
        visitationdRemarks: visitationdRemarks,
        visitationdImages: visitationdImages,
      );

      emit(LampiranLoaded(model: List.from(modelEntryImage)));
    }
  }

  void deleteData(String visitationdOid) {
    modelEntryImage.removeWhere((e) => e.visitationdOid == visitationdOid);
    emit(LampiranLoaded(model: List.from(modelEntryImage)));
  }
}
