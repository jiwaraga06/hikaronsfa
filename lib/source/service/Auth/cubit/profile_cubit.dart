import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void getProfile(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString('username');
    emit(ProfileLoading());
    if (username != null) {
      emit(ProfileLoaded(username: username));
    }
  }
}
