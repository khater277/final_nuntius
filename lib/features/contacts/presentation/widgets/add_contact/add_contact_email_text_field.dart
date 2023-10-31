import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_text_field_and_title.dart';
import 'package:flutter/material.dart';

class AddContactEmailTextField extends StatelessWidget {
  const AddContactEmailTextField({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return AddContactTextFieldAndTitle(
      controller: emailController,
      title: 'Email',
      hint: 'email address..',
      inputType: TextInputType.emailAddress,
      icon: IconBroken.Message,
    );
  }
}
