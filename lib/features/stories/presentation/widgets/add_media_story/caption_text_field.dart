import 'package:final_nuntius/core/shared_widgets/text_form_field.dart';
import 'package:flutter/material.dart';

class CaptionTextField extends StatelessWidget {
  final TextEditingController controller;
  const CaptionTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        controller: controller,
        inputType: TextInputType.text,
        hintText: "add a caption...",
      ),
    );
  }
}
