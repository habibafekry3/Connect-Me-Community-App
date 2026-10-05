import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(const AuthInitial());

  // Check if the user is already authenticated
  void checkAuthStatus() {
    final user = _authService.currentUser;

    if (user != null) {
      emit(const Authenticated());
    } else {
      emit(const Unauthenticated());
    }
  }

  //Login method
  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    try {
      await _authService.signIn(email: email, password: password);

      emit(const Authenticated());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  // SignUp method
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final userCredential = await _authService.signUp(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(fullName);

      emit(const AuthSignUpSuccess());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  // Logout method
  Future<void> logout() async {
    await _authService.signOut();

    emit(const Unauthenticated());
  }

  // Error handling method
  String _getErrorMessage(Object error) {
    return error.toString();
  }
}
