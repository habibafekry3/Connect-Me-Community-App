
import 'user_model.dart';

class UserModelBuilder {
  String? _id;
  String? _fullName;
  String? _email;
  String? _photoUrl;

  UserModelBuilder setId(String id) {
    _id = id;
    return this;
  }

  UserModelBuilder setFullName(String fullName) {
    _fullName = fullName;
    return this;
  }

  UserModelBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserModelBuilder setPhotoUrl(String? photoUrl) {
    _photoUrl = photoUrl;
    return this;
  }

  UserModel build() {
    if (_id == null || _fullName == null || _email == null) {
      throw StateError(
        'id, fullName, and email are required to build UserModel.',
      );
    }

    return UserModel(
      id: _id!,
      fullName: _fullName!,
      email: _email!,
      photoUrl: _photoUrl,
    );
  }
}
