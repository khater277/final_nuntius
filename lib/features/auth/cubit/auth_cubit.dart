import 'dart:io';

import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_preferences/shared_pref_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit({required this.authRepository}) : super(const AuthState.initial());

  static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController? phoneController;
  TextEditingController? nameController;

  void initPhoneController() {
    phoneController = TextEditingController();
    emit(const AuthState.initController());
  }

  void disposePhoneController() {
    phoneController!.dispose();
    emit(const AuthState.disposeController());
  }

  void initNameController() {
    bool condition = HiveHelper.getCurrentUser() != null &&
        HiveHelper.getCurrentUser()!.name != "";
    nameController = TextEditingController(
        text: condition ? HiveHelper.getCurrentUser()!.name : null);
    emit(const AuthState.initController());
  }

  void disposeNameController() {
    nameController!.dispose();
    emit(const AuthState.disposeController());
  }

  late String id;
  void signInWithPhoneNumber() async {
    emit(const AuthState.signInWithPhoneNumberLoading());
    print('+2${phoneController!.text}');
    await authRepository.verifyPhoneNumber(
      phoneNumber: phoneController!.text,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
    );
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(const AuthState.verificationCompleted());
    } on FirebaseAuthException catch (error) {
      emit(AuthState.errorState(ServerFailure(
        error: error,
        type: NetworkErrorTypes.auth,
      ).getMessage()));
    }
  }

  void _verificationFailed(FirebaseAuthException error) {
    emit(AuthState.errorState(
        ServerFailure(error: error, type: NetworkErrorTypes.auth)
            .getMessage()));
  }

  void _codeSent(String verificationId, int? resendToken) {
    id = verificationId;
    emit(const AuthState.codeSent());
  }

  void submitOtp(String smsCode) async {
    emit(const AuthState.submitOtpLoading());
    final response = await authRepository.signInWithPhoneNumber(
      verificationId: id,
      smsCode: smsCode,
    );

    response.fold(
      (failure) {
        emit(AuthState.errorState(failure.getMessage()));
      },
      (userCredential) {
        emit(const AuthState.submitOtp());
      },
    );
  }

  ImagePicker picker = ImagePicker();
  File? profileImage;
  double? profileImagePercentage;

  Future<void> pickProfileImage() async {
    emit(const AuthState.pickProfileImageLoading());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(const AuthState.pickProfileImage());
    } else {
      debugPrint("NOT SELECTED");
      emit(const AuthState.pickProfileImageError("NOT SELECTED"));
    }
  }

  void uploadImageToStorage() {
    final response = authRepository.uploadImageToStorage(
        collectionName: Collections.profileImages, image: profileImage!);
    response.fold(
      (failure) {},
      (taskSnapshot) {
        taskSnapshot!.listen((event) async {
          switch (event.state) {
            case TaskState.running:
              profileImagePercentage =
                  event.bytesTransferred / event.totalBytes;
              debugPrint("===============> $profileImagePercentage");
              emit(const AuthState.uploadImageToStorageLoading());
              break;
            case TaskState.paused:
              break;
            case TaskState.success:
              addUserToFirestore(image: await event.ref.getDownloadURL());
              break;
            case TaskState.canceled:
              emit(const AuthState.uploadImageToStorageError(
                  "The operation has been cancelled."));
              break;
            case TaskState.error:
              emit(const AuthState.uploadImageToStorageError(
                  "The operation has been failed."));
              break;
          }
        });
      },
    );
  }

  void addUserToFirestore({
    String? image,
  }) async {
    bool condition = image == null;
    print(condition);
    if (condition) emit(const AuthState.addUserToFirestoreLoading());
    final token = await FirebaseMessaging.instance.getToken();
    UserData user = UserData(
      token: token,
      name: nameController!.text.isNotEmpty ? nameController!.text : 'user',
      uId: await SharedPrefHelper.getUid(),
      phone: "+2${phoneController!.text}",
      image: image ?? "",
      inCall: false,
    );
    final response = await authRepository.addUserToFirestore(user: user);
    response.fold(
      (failure) {
        emit(AuthState.addUserToFirestoreError(failure.getMessage()));
      },
      (result) {
        emit(const AuthState.addUserToFirestore());
      },
    );
  }

  void getUser() async {
    final response = await authRepository.getUserFromFirestore(uid: '123');
    response.fold((l) => emit(AuthState.pickProfileImageError(l.getMessage())),
        (r) {
      print("DONNNNNNE");
      emit(const AuthState.pickProfileImage());
    });
  }
}
