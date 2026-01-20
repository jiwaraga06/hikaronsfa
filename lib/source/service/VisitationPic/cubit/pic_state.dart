part of 'pic_cubit.dart';

@immutable
sealed class PicState {}

final class PicInitial extends PicState {}

final class PicLoaded extends PicState {
  final List<ModelEntryPIC>? model;

  PicLoaded({required this.model});
}
