
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final String? profileImageBase64;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.isLoading = false,
    this.profileImageBase64,
    this.errorMessage,
    this.successMessage,
  });

  @override
  List<Object?> get props => [
        isLoading,
        profileImageBase64,
        errorMessage,
        successMessage,
      ];
}
