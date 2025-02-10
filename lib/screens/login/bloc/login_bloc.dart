// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'Login_event.dart';
// import 'Login_state.dart';
// import '../../repositories/Login_repository.dart';

// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final LoginRepository LoginRepository;

//   LoginBloc(this.LoginRepository) : super(LoginInitial()) {
//     on<LoginRequested>((event, emit) async {
//       emit(LoginLoading());
//       try {
//         final token = await LoginRepository.login(event.username, event.password);
//         emit(LoginLoginenticated(token));
//       } catch (e) {
//         emit(LoginError('Login failed. Please check your credentials.'));
//       }
//     });

//     on<LogoutRequested>((event, emit) async {
//       emit(LoginLoading());
//       try {
//         await LoginRepository.logout(event.token);
//         emit(LoginInitial());
//       } catch (e) {
//         emit(LoginError('Logout failed.'));
//       }
//     });

//     on<FetchProfile>((event, emit) async {
//       emit(LoginLoading());
//       try {
//         final profile = await LoginRepository.fetchProfile(event.token);
//         emit(ProfileLoaded(profile));
//       } catch (e) {
//         emit(LoginError('Failed to fetch profile.'));
//       }
//     });
//   }
// }
