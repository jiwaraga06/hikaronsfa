import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitImage.dart';
import 'package:meta/meta.dart';

part 'update_visitation_image_state.dart';

class UpdateVisitationImageCubit extends Cubit<UpdateVisitationImageState> {
  final RepositoryVisitImage? repository;
  UpdateVisitationImageCubit({this.repository}) : super(UpdateVisitationImageInitial());
}
