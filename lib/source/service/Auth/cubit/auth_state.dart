part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthProfile extends AuthState {
  final String? username;

  AuthProfile({required this.username});
}

final class AuthLoading extends AuthState {}

final class AuthFailed extends AuthState {
  final int? statusCode;
  final dynamic json;

  AuthFailed({required this.statusCode, required this.json});
}
final class AuthLoaded extends AuthState {
  final int? statusCode;
  final dynamic json;

  AuthLoaded({required this.statusCode, required this.json});
}
