import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitImage.dart';
import 'package:meta/meta.dart';

part 'insert_visitation_image_state.dart';

class InsertVisitationImageCubit extends Cubit<InsertVisitationImageState> {
  final RepositoryVisitImage? repository;
  InsertVisitationImageCubit({this.repository}) : super(InsertVisitationImageInitial());
}
