import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(const AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      await _authService.signIn(
        email: email,
        password: password,
      );

      emit(const AuthSuccess());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      await _authService.signUp(
        email: email,
        password: password,
      );

      emit(const AuthSuccess());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  String _getErrorMessage(Object error) {
    return error.toString();
  }
}