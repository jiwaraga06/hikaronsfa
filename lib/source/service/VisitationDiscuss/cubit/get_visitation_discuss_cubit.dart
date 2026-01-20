import 'package:bloc/bloc.dart';
import 'package:hikaronsfa/source/repository/RepositoryVisitDiscuss.dart';
import 'package:meta/meta.dart';

part 'get_visitation_discuss_state.dart';

class GetVisitationDiscussCubit extends Cubit<GetVisitationDiscussState> {
  final RepositoryVisitDiscuss? repository;
  GetVisitationDiscussCubit({this.repository}) : super(GetVisitationDiscussInitial());
}
