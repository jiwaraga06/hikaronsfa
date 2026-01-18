part of 'get_design_cubit.dart';

@immutable
sealed class GetDesignState {}

final class GetDesignInitial extends GetDesignState {}

final class GetDesignLoading extends GetDesignState {}

final class GetDesignLoaded extends GetDesignState {
  final int? statusCode;
  final List<ModelDesign> modelDesign;

  GetDesignLoaded({required this.statusCode, required this.modelDesign});
}

final class GetDesignFailed extends GetDesignState {
  final int? statusCode;
  final dynamic json;

  GetDesignFailed({required this.statusCode, required this.json});
}
