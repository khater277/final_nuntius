part of 'contacts_cubit.dart';

@freezed
class ContactsState with _$ContactsState {
  const factory ContactsState.initial() = _Initial;
  const factory ContactsState.getContactsLoading() = _GetContactsLoading;
  const factory ContactsState.getContacts() = _GetContacts;
  const factory ContactsState.getContactsError() = _GetContactsError;
}
