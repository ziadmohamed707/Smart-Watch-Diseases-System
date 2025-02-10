abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String username;
  final String password;

  LoginRequested(this.username, this.password);
}

class LogoutRequested extends LoginEvent {
  final String token;

  LogoutRequested(this.token);
}

class FetchProfile extends LoginEvent {
  final String token;

  FetchProfile(this.token);
}
