import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:flutter/material.dart';

class TextLastMessage extends StatelessWidget {
  final String message;

  const TextLastMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SecondaryText(
      text: message,
      size: FontSize.s12,
    );
  }
}
