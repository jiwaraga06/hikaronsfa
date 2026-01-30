import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryAbsensi.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'check_status_absen_state.dart';

class CheckStatusAbsenCubit extends Cubit<CheckStatusAbsenState> {
  final RepositoryAbsensi? repository;
  CheckStatusAbsenCubit({this.repository}) : super(CheckStatusAbsenInitial());
  void checkStatusCheckIn(context) async {
    final pref = await SharedPreferences.getInstance();
    final salesId = pref.getString("user_as_sales_id");

    final responseCustomer = await repository!.lastCheckIn(salesId, context);

    final jsonCustomer = responseCustomer.data;

    final customerOut = jsonCustomer?['data']?['attnd_date_out'];
    bool isReadyCheckin = false;
    if (customerOut != null) {
      isReadyCheckin = true;
    } else {
      isReadyCheckin = false;
    }
    print("\n \n STATUS ABSEN : $isReadyCheckin");
    emit(CheckStatusAbsenLoaded(isReadyCheckin: isReadyCheckin));
  }
}
