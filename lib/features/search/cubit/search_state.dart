part of 'search_cubit.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.initControllers() = _InitControllers;
  const factory SearchState.disposeControllers() = _DisposeControllers;
  const factory SearchState.onChangeSearchTextFieldLoading() =
      _OnChangeSearchTextFieldLoading;
  const factory SearchState.onChangeSearchTextField() =
      _OnChangeSearchTextField;
}
