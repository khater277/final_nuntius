part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.changeNavBarLoading() = _ChangeNavBarLoading;
  const factory HomeState.changeNavBar() = _ChangeNavBar;
}
