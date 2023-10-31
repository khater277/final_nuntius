import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_text_field_and_title.dart';
import 'package:flutter/material.dart';

class AddContactCompanyTextField extends StatelessWidget {
  const AddContactCompanyTextField({
    super.key,
    required this.companyController,
  });

  final TextEditingController companyController;

  @override
  Widget build(BuildContext context) {
    return AddContactTextFieldAndTitle(
      controller: companyController,
      title: 'Company',
      hint: 'company..',
      inputType: TextInputType.text,
      icon: IconBroken.Work,
    );
  }
}
