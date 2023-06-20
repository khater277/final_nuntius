// ignore_for_file: use_build_context_synchronously

import 'package:contacts_service/contacts_service.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts_cubit.freezed.dart';
part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(const ContactsState.initial());

  static ContactsCubit get(context) => BlocProvider.of(context);

  List<Contact> contacts = [];
  List<UserData> users = [];
  void getContacts(context) {
    contacts = HomeCubit.get(context).contacts;
    users = HomeCubit.get(context).users;
    emit(const ContactsState.getContacts());
  }

  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? companyController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    companyController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    emit(const ContactsState.initControllers());
  }

  void disposeControllers() {
    firstNameController!.dispose();
    lastNameController!.dispose();
    companyController!.dispose();
    emailController!.dispose();
    phoneController!.dispose();
    emit(const ContactsState.disposeControllers());
  }

  Future<void> addNewContact({
    required Contact contact,
    required BuildContext context,
  }) async {
    emit(const ContactsState.addContactLoading());
    try {
      await ContactsService.addContact(contact);
      HomeCubit.get(context).getContacts(isAddContact: true);
      firstNameController!.clear();
      lastNameController!.clear();
      companyController!.clear();
      emailController!.clear();
      phoneController!.clear();
      emit(const ContactsState.addContact());
    } catch (error) {
      emit(const ContactsState.addContactError(
          "we faces some troubles to add that contact , please try again later."));
    }
  }
}
