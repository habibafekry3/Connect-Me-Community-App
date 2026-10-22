import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      debugPrint('Device supported: $isSupported');
      debugPrint('Can check biometrics: $canCheckBiometrics');
      debugPrint('Available biometrics: $availableBiometrics');

      if (!isSupported) {
        debugPrint('Device authentication is not supported.');
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your profile',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (e) {
      debugPrint('Local auth exception: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      debugPrint('Biometric error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }
}
