import 'package:contacts_service/contacts_service.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
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
}
