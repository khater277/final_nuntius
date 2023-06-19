import 'package:final_nuntius/features/calls/presentation/screens/calls_screen.dart';
import 'package:final_nuntius/features/chats/presentation/screen/chats_screen.dart';
import 'package:final_nuntius/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:final_nuntius/features/stories/presentation/screens/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial());
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
}
