import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitImage.dart';
import 'package:meta/meta.dart';

part 'get_visitation_image_state.dart';

class GetVisitationImageCubit extends Cubit<GetVisitationImageState> {
  final RepositoryVisitImage? repository;
  GetVisitationImageCubit({this.repository}) : super(GetVisitationImageInitial());
}
