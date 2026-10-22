
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/profile_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileService) : super(const ProfileState());

  final ProfileService _profileService;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadPhoto() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 50,
      );

      if (image == null || isClosed) return;

      emit(ProfileState(
        isLoading: true,
        profileImageBase64: state.profileImageBase64,
      ));

      final compressedBytes =
          await FlutterImageCompress.compressWithFile(
        image.path,
        minWidth: 400,
        minHeight: 400,
        quality: 35,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null || compressedBytes.isEmpty) {
        throw Exception('Image compression failed.');
      }

      final compressedImage = XFile.fromData(
        compressedBytes,
        mimeType: 'image/jpeg',
        name: 'profile.jpg',
      );

      final imageBase64 =
          await _profileService.uploadProfilePhoto(compressedImage);

      if (isClosed) return;

      emit(ProfileState(
        profileImageBase64: imageBase64,
        successMessage: 'profileImageUpdated',
      ));
    } catch (e) {
      if (isClosed) return;

      emit(ProfileState(
        profileImageBase64: state.profileImageBase64,
        errorMessage: e.toString(),
      ));
    }
  }
}
