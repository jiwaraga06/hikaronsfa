part of 'discuss_cubit.dart';

@immutable
sealed class DiscussState {}

final class DiscussInitial extends DiscussState {}

final class DiscussLoaded extends DiscussState {
  final List<ModelEntryDiscuss>? model;

  DiscussLoaded({required this.model});
}
