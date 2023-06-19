part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.changeNavBarLoading() = _ChangeNavBarLoading;
  const factory HomeState.changeNavBar() = _ChangeNavBar;
  const factory HomeState.getContactsLoading() = _GetContactsLoading;
  const factory HomeState.getContacts() = _GetContacts;
  const factory HomeState.getContactsError() = _GetContactsError;
}
