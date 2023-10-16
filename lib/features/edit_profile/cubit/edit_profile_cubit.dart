import 'dart:io';

import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:final_nuntius/features/edit_profile/data/repositories/edit_profile_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_profile_state.dart';
part 'edit_profile_cubit.freezed.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final EditProfileRepository editProfileRepository;
  final AuthRepository authRepository;
  EditProfileCubit(
      {required this.editProfileRepository, required this.authRepository})
      : super(const EditProfileState.initial());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  ImagePicker picker = ImagePicker();
  File? profileImage;
  double? profileImagePercentage;

  void initEditProfileScreen() {
    profileImage = null;
    profileImagePercentage = null;
    emit(const EditProfileState.initEditProfileScreen());
  }

  Future<void> pickProfileImage() async {
    emit(const EditProfileState.pickProfileImageLoading());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(const EditProfileState.pickProfileImage());
    } else {
      debugPrint("NOT SELECTED");
      emit(const EditProfileState.pickProfileImageError("NOT SELECTED"));
    }
  }

  void uploadProfileImage() async {
    emit(const EditProfileState.updateProfileImageLoading());
    final response = await authRepository.uploadImageToStorage(
        collectionName: Collections.profileImages, file: profileImage!);
    response.fold(
      (failure) {
        emit(EditProfileState.updateProfileImageError(failure.getMessage()));
      },
      (result) {
        result!.fold(
          (url) => updateProfileImage(image: url),
          (taskSnapshot) {
            taskSnapshot.listen((event) async {
              switch (event.state) {
                case TaskState.running:
                  emit(const EditProfileState.updateProfileImageLoading());
                  profileImagePercentage =
                      event.bytesTransferred / event.totalBytes;
                  debugPrint("===============> $profileImagePercentage");
                  emit(const EditProfileState.getProfileImagePercentage());
                  break;
                case TaskState.paused:
                  break;
                case TaskState.success:
                  updateProfileImage(image: await event.ref.getDownloadURL());
                  break;
                case TaskState.canceled:
                  emit(const EditProfileState.updateProfileImageError(
                      "The operation has been cancelled."));
                  break;
                case TaskState.error:
                  emit(const EditProfileState.updateProfileImageError(
                      "The operation has been failed."));
                  break;
              }
            });
          },
        );
      },
    );
  }

  void updateProfileImage({required String image}) async {
    final response =
        await editProfileRepository.updateProfileData(data: {"image": image});
    response.fold(
      (failure) =>
          emit(EditProfileState.updateProfileImageError(failure.getMessage())),
      (result) {
        profileImage = null;
        profileImagePercentage = null;
        HiveHelper.setCurrentUser(
            user: HiveHelper.getCurrentUser()!.copyWith(image: image));
        emit(const EditProfileState.updateProfileImage());
      },
    );
  }

  void updateProfileName({required String name}) async {
    emit(const EditProfileState.updateProfileNameLoading());
    final response =
        await editProfileRepository.updateProfileData(data: {"name": name});
    response.fold(
      (failure) =>
          emit(EditProfileState.updateProfileNameError(failure.getMessage())),
      (result) {
        HiveHelper.setCurrentUser(
            user: HiveHelper.getCurrentUser()!.copyWith(name: name));
        emit(const EditProfileState.updateProfileName());
      },
    );
  }
}
