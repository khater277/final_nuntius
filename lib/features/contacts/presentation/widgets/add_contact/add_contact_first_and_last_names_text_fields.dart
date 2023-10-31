import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/add_contact/add_contact_text_field_and_title.dart';
import 'package:flutter/material.dart';

class AddContactFirstAndLastNamesTextFields extends StatelessWidget {
  const AddContactFirstAndLastNamesTextFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AddContactTextFieldAndTitle(
            controller: firstNameController,
            title: "First name",
            hint: 'first name..',
            inputType: TextInputType.name,
            icon: IconBroken.Profile,
            validator: (value) {
              if (firstNameController.text.isEmpty) {
                return """can't be empty""";
              }
              return null;
            },
          ),
        ),
        SizedBox(width: AppWidth.w10),
        Expanded(
          child: AddContactTextFieldAndTitle(
            controller: lastNameController,
            title: "Last name",
            hint: 'last name..',
            inputType: TextInputType.name,
            icon: IconBroken.Profile,
            validator: (value) {
              if (lastNameController.text.isEmpty) {
                return """can't be empty""";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
