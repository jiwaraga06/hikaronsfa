import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hikaronsfa/source/env/env.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitImage.dart';
import 'package:meta/meta.dart';

part 'insert_visitation_image_state.dart';

class InsertVisitationImageCubit extends Cubit<InsertVisitationImageState> {
  final RepositoryVisitImage? repository;
  InsertVisitationImageCubit({this.repository}) : super(InsertVisitationImageInitial());
  void insertImage(context) async {
    final formData = FormData();

    for (int i = 0; i < modelEntryImage.length; i++) {
      final a = modelEntryImage[i];

      formData.fields.addAll([
        MapEntry('$i[visitationd_visitation_oid]', a.visitationdVisitationOid!),
        MapEntry('$i[visitationd_oid]', a.visitationdOid!),
        MapEntry('$i[visitationd_remarks]', a.visitationdRemarks ?? ''),
      ]);

      formData.files.addAll([MapEntry('$i[visitationd_image]', await MultipartFile.fromFile(a.visitationdImages!.path, filename: a.visitationdImages!.name))]);
    }
    print("\n\n LAMPIRAN : ${formData.files}");
    emit(InsertVisitationImageLoading());
    final response = await repository!.addVisitImage(formData, context);
    if (response == null) {
      emit(InsertVisitationImageFailed(statusCode: 500, json: {"message": "No Response"}));
      return;
    }
    var json = response.data;
    var statusCode = response.statusCode ?? 500;
    print("\nDISKUSI : $json");
    if (statusCode == 200) {
      emit(InsertVisitationImageLoaded(statusCode: statusCode, json: json));
    } else {
      emit(InsertVisitationImageFailed(statusCode: 500, json: json));
    }
  }
}
