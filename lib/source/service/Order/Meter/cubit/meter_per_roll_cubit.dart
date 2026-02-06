import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryOrder.dart';
import 'package:meta/meta.dart';

part 'meter_per_roll_state.dart';

class MeterPerRollCubit extends Cubit<MeterPerRollState> {
  final RepositoryOrder? repository;
  MeterPerRollCubit({this.repository}) : super(MeterPerRollInitial());

  void getMeter(ptcId, context) async {
    emit(MeterPerRollLoading());
    final response = await repository!.meterPerRoll(ptcId, context);
    if (response == null) {
      emit(MeterPerRollFailed(statusCode: 500, message: "NO Response"));
    }
    var json = response.data;
    var statusCode = response.statusCode;
    
    if (statusCode == 200) {
      emit(MeterPerRollLoaded(statusCode: statusCode, message: json['message'], json: json));
    } else {
      emit(MeterPerRollFailed(statusCode: statusCode, message: json['message']));
    }
  }
}
