import 'package:contacts_service/contacts_service.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/auth/data/repositories/auth_repository.dart';
import 'package:final_nuntius/features/calls/presentation/screens/calls_screen.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/chats/presentation/screen/chats_screen.dart';
import 'package:final_nuntius/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:final_nuntius/features/home/data/repositories/home_repository.dart';
import 'package:final_nuntius/features/stories/presentation/screens/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  final AuthRepository authRepository;

  HomeCubit({
    required this.homeRepository,
    required this.authRepository,
  }) : super(const HomeState.initial());
  static HomeCubit get(context) => BlocProvider.of(context);

  // bottom navigation bar screens
  List<Widget> screens = [
    const ChatsScreen(),
    const StoriesScreen(),
    const CallsScreen(),
    const ContactsScreen()
  ];
  int navBarIndex = 0;

  void changeNavBar({required int index}) {
    emit(const HomeState.changeNavBarLoading());
    navBarIndex = index;
    emit(const HomeState.changeNavBar());
  }

  List<Contact> contacts = [];
  List<UserData> users = [];
  Map<String, String> phones = {};
  UserData? user;

  void initUser({required UserData user}) {
    this.user = user;
    emit(const HomeState.initUser());
  }

  void disposeUser() {
    user = null;
    emit(const HomeState.disposeUser());
  }

  void getChats(BuildContext context) {
    ChatsCubit.get(context).getChats(context);
  }

  void getContacts({bool? isAddContact}) async {
    if (isAddContact != true) emit(const HomeState.getContactsLoading());
    try {
      contacts = await ContactsService.getContacts(withThumbnails: false);
      await _handleContacts();
      await _handleUsers();
      final response = await authRepository.addUserToFirestore(
          user: HiveHelper.getCurrentUser()!.copyWith(contacts: phones));
      response.fold(
        (failure) {
          print("==========>${failure.getMessage()}");
          emit(const HomeState.getContactsError());
        },
        (result) => emit(const HomeState.getContacts()),
      );
      print(contacts.length);
    } catch (error) {
      // users = HiveHelper.getAllUsers() ?? [];
      emit(const HomeState.getContactsError());
    }
  }

  Future<void> _handleContacts() async {
    for (int i = 0; i < contacts.length; i++) {
      final oldContact = contacts[i];
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
        print("asd=======>${users.first.name}");
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
                    HiveHelper.getCurrentUser()!.phone)) {
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
}
