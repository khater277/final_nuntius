import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_text_field_and_title.dart';
import 'package:flutter/material.dart';

class AddContactPhoneTextField extends StatelessWidget {
  const AddContactPhoneTextField({
    super.key,
    required this.phoneController,
  });

  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return AddContactTextFieldAndTitle(
      controller: phoneController,
      title: 'Phone number',
      hint: 'phone number..',
      inputType: TextInputType.phone,
      icon: IconBroken.Call,
      validator: (value) {
        if (phoneController.text.isEmpty) {
          return """can't be empty""";
        } else if (phoneController.text.length != 11) {
          return "invalid phone number";
        }
        return null;
      },
    );
  }
}
