import 'dart:io';

import 'package:collection/collection.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:final_nuntius/core/errors/failures.dart';
import 'package:final_nuntius/core/firebase/collections_keys.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_preferences/shared_pref_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:final_nuntius/features/home/data/repositories/home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final HomeRepository homeRepository;
  AuthCubit({
    required this.authRepository,
    required this.homeRepository,
  }) : super(const AuthState.initial());

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
    final response = await authRepository.verifyPhoneNumber(
      phoneNumber: phoneController!.text,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
    );

    response.fold(
      (failure) => emit(AuthState.errorState(failure.getMessage())),
      (result) {},
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

  void uploadImageToStorage() async {
    emit(const AuthState.uploadImageToStorageLoading());
    final response = await authRepository.uploadImageToStorage(
        collectionName: Collections.profileImages, file: profileImage!);
    response.fold(
      (failure) {
        emit(AuthState.uploadImageToStorageError(failure.getMessage()));
      },
      (result) {
        result!.fold(
          (url) {
            addUserToFirestore(image: url);
          },
          (taskSnapshot) {
            taskSnapshot.listen((event) async {
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
      },
    );
  }

  List<Contact> contacts = [];
  List<UserData> users = [];
  Map<String, String> phones = {};
  void addUserToFirestore({
    String? image,
  }) async {
    bool condition = image == null;
    if (condition) emit(const AuthState.addUserToFirestoreLoading());
    try {
      contacts = await ContactsService.getContacts(withThumbnails: false);
      await _handleContacts();
      await _handleUsers();
      final token = await FirebaseMessaging.instance.getToken();
      UserData user = UserData(
        token: token,
        name: nameController!.text.isNotEmpty ? nameController!.text : 'user',
        uId: await SharedPrefHelper.getUid(),
        phone: "+2${phoneController!.text}",
        image: image ?? "",
        inCall: false,
        contacts: phones,
      );
      final response = await authRepository.addUserToFirestore(user: user);
      response.fold(
        (failure) {
          emit(AuthState.addUserToFirestoreError(failure.getMessage()));
        },
        (result) {
          HiveHelper.setCurrentUser(user: user);
          emit(const AuthState.addUserToFirestore());
        },
      );
    } catch (error) {
      print("===========>${error.toString()}");
      emit(const AuthState.addUserToFirestoreError(
          'unable to complete the process , something went wrong'));
    }
  }

  Future<void> _handleContacts() async {
    for (int i = 0; i < contacts.length; i++) {
      final oldContact = contacts[i];
      // print("=========>${oldContact} ${i + 1} ${contacts.length}");
      if (oldContact.phones!.isNotEmpty) {
        if (!oldContact.phones!.first.value!.startsWith('+2')) {
          final Contact newContact = Contact(
            displayName: oldContact.displayName,
            emails: oldContact.emails,
            company: oldContact.company,
            phones: [
              Item(
                label: oldContact.phones![0].label,
                value: "+2${oldContact.phones![0].value!.replaceAll(' ', '')}",
              )
            ],
          );
          contacts[i] = newContact;
        }
      }
    }
  }

  Future<void> _handleUsers() async {
    final response = await homeRepository.getAllUsersFromFirestore();

    response.fold(
      (failure) {
        users = HiveHelper.getAllUsers() ?? [];
        users.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
        );
      },
      (usersData) {
        for (int i = 0; i < contacts.length; i++) {
          final user = usersData.firstWhereOrNull((element) =>
              contacts[i].phones!.isNotEmpty
                  ? element.phone == contacts[i].phones!.first.value
                  : false);

          if (user != null) {
            final existedUser = users
                .firstWhereOrNull((element) => element.phone == user.phone);
            if (existedUser == null &&
                (contacts[i].phones!.first.value != null) &&
                (contacts[i].phones!.first.value !=
                    "+2${phoneController!.text}")) {
              users.add(user.copyWith(name: contacts[i].displayName));
              phones[contacts[i].phones!.first.value!] =
                  contacts[i].displayName!;
            }
          }
        }
        HiveHelper.setAllUsers(users: users);
        users.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
        );
      },
    );
  }

  void updateUserToken() async {
    emit(const AuthState.updateUserTokenLoading());
    final token = await FirebaseMessaging.instance.getToken();
    final response = await authRepository.updateUserToken(token: token!);
    response.fold(
      (failure) {
        emit(AuthState.updateUserTokenError(failure.getMessage()));
      },
      (result) {
        emit(const AuthState.updateUserToken());
      },
    );
  }
}
