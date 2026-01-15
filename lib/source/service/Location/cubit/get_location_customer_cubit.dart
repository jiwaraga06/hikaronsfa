import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/env/address.dart';
import 'package:hikaronsfa/source/env/convertLocation.dart';
import 'package:hikaronsfa/source/repository/RepositoryLocation.dart';
import 'package:meta/meta.dart';

part 'get_location_customer_state.dart';

class GetLocationCustomerCubit extends Cubit<GetLocationCustomerState> {
  final RepositoryLocation? repository;
  GetLocationCustomerCubit({this.repository}) : super(GetLocationCustomerInitial());

  void reset() {
    emit(GetLocationCustomerInitial());
  }

  Future<void> getLocationCustomer(customerId, context) async {
    emit(GetLocationCustomerLoading());

    final response = await repository!.getLocationCustomer(customerId, context);

    if (response == null) {
      emit(GetLocationCustomerFailed(statusCode: 500, json: {"message": "Response kosong"}));
      return;
    }

    final statusCode = response.statusCode ?? 500;
    final json = response.data;

    print("\n GET LOCATION CUSTOMER : $json");

    if (statusCode == 200 && json != null && json['data'] != null) {
      try {
        var koordinat = getLatLng(json['data']['confl_latitude_longitude']);

        var alamat = await getFullAddress(latitude: koordinat.latitude, longitude: koordinat.longitude);

        emit(
          GetLocationCustomerLoaded(
            statusCode: statusCode,
            json: {"alamat": alamat.toString()},
            latitudePlace: koordinat.latitude,
            longitudePlace: koordinat.longitude,
          ),
        );
      } catch (e) {
        emit(GetLocationCustomerFailed(statusCode: 500, json: {"message": "Gagal parsing lokasi"}));
      }
    } else {
      emit(GetLocationCustomerFailed(statusCode: statusCode, json: json ?? {"message": "Unknown error"}));
    }
  }
}
