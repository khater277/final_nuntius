part of 'edit_profile_cubit.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState.initial() = _Initial;
  const factory EditProfileState.initEditProfileScreen() =
      _initEditProfileScreen;
  const factory EditProfileState.pickProfileImageLoading() =
      _PickProfileImageLoading;
  const factory EditProfileState.pickProfileImage() = _PickProfileImage;
  const factory EditProfileState.pickProfileImageError(String errorMsg) =
      _PickProfileImageError;

  const factory EditProfileState.getProfileImagePercentage() =
      _GetProfileImagePercentage;
  const factory EditProfileState.updateProfileImageLoading() =
      _updateProfileImageLoading;
  const factory EditProfileState.updateProfileImage() = _updateProfileImage;
  const factory EditProfileState.updateProfileImageError(String errorMsg) =
      _updateProfileImageError;
  const factory EditProfileState.updateProfileNameLoading() =
      _updateProfileNameLoading;
  const factory EditProfileState.updateProfileName() = _updateProfileName;
  const factory EditProfileState.updateProfileNameError(String errorMsg) =
      _updateProfileNameError;
}
