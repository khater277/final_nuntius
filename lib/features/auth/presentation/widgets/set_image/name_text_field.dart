import 'package:final_nuntius/core/shared_widgets/text_form_field.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  final TextEditingController nameController;
  const NameTextField({
    super.key,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.w20),
      child: CustomTextField(
        hintText: "enter your name..",
        controller: nameController,
        inputType: TextInputType.name,
      ),
    );
  }
}
