import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'check_permission_state.dart';

class CheckPermissionCubit extends Cubit<CheckPermissionState> {
  CheckPermissionCubit() : super(CheckPermissionInitial());
  Future<void> requestCameraAndLocation() async {
    // 1. Request CAMERA dulu
    final cameraStatus = await Permission.camera.request();

    if (!cameraStatus.isGranted) {
      emit(CheckPermissionDenied(message: "Izin kamera ditolak"));
      return;
    }

    // 2. Kalau camera OK, baru request LOCATION
    final locationStatus = await Permission.location.request();

    if (!locationStatus.isGranted) {
      emit(CheckPermissionDenied(message: "Izin lokasi ditolak"));
      return;
    }

    // 3. Kalau semua OK
    emit(CheckPermissionGranted());
  }
}
