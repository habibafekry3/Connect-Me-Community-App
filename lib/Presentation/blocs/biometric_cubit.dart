
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/biometric_service.dart';

enum BiometricStatus {
  initial,
  authenticating,
  authenticated,
  failed,
}

class BiometricCubit extends Cubit<BiometricStatus> {
  BiometricCubit(this._biometricService)
      : super(BiometricStatus.initial);

  final BiometricService _biometricService;

  Future<bool> authenticate() async {
    emit(BiometricStatus.authenticating);

    try {
      final success = await _biometricService.authenticate();

      emit(
        success
            ? BiometricStatus.authenticated
            : BiometricStatus.failed,
      );

      return success;
    } catch (_) {
      emit(BiometricStatus.failed);
      return false;
    }
  }
}
