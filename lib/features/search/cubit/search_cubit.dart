import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_cubit.freezed.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState.initial());

  static SearchCubit get(context) => BlocProvider.of(context);

  TextEditingController? searchController;

  List<UserData> users = [];
  List<UserData> searchResult = [];

  void initSearch({required BuildContext context}) {
    searchController = TextEditingController();
    users = HomeCubit.get(context).users;
    emit(const SearchState.initControllers());
  }

  void disposeSearch() {
    searchController!.dispose();
    searchResult = [];
    emit(const SearchState.disposeControllers());
  }

  void onChangeSearchTextField({required String value}) {
    emit(const SearchState.onChangeSearchTextFieldLoading());
    List<UserData> nameResult = users.where((element) {
      return element.name!.toLowerCase().contains(value.toLowerCase());
    }).toList();

    List<UserData> contactsPhoneResult = users.where((element) {
      return element.phone!.toLowerCase().contains(value.toLowerCase());
    }).toList();

    searchResult = (nameResult + contactsPhoneResult).toSet().toList();
    searchResult.sort(
      (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
    );
    emit(const SearchState.onChangeSearchTextField());
  }

  void clearSearchTextField() {
    emit(const SearchState.onChangeSearchTextFieldLoading());
    searchController!.clear();
    emit(const SearchState.onChangeSearchTextField());
  }
}
