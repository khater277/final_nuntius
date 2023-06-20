part of 'contacts_cubit.dart';

@freezed
class ContactsState with _$ContactsState {
  const factory ContactsState.initial() = _Initial;
  const factory ContactsState.getContactsLoading() = _GetContactsLoading;
  const factory ContactsState.getContacts() = _GetContacts;
  const factory ContactsState.getContactsError() = _GetContactsError;
  const factory ContactsState.initControllers() = _InitControllers;
  const factory ContactsState.disposeControllers() = _DisposeControllers;
  const factory ContactsState.addContactLoading() = _AddContactLoading;
  const factory ContactsState.addContact() = _AddContact;
  const factory ContactsState.addContactError(String errorMsg) =
      _AddContactError;
}
