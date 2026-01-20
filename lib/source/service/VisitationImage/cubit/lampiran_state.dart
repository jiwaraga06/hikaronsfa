part of 'lampiran_cubit.dart';

@immutable
sealed class LampiranState {}

final class LampiranInitial extends LampiranState {}

final class LampiranLoaded extends LampiranState {
  final List<ModelEntryImage> model;

  LampiranLoaded({required this.model});
}
