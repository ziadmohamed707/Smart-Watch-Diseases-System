abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoginenticated extends LoginState {
  final String token;

  LoginLoginenticated(this.token);
}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}

class ProfileLoaded extends LoginState {
  final Map<String, dynamic> profile;

  ProfileLoaded(this.profile);
}
