import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:flutter/material.dart';

class ChatNameAndDate extends StatelessWidget {
  final String name;
  final String date;
  const ChatNameAndDate({
    Key? key,
    required this.name,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LargeHeadText(
            text: name,
            size: FontSize.s14,
          ),
        ),
        SecondaryText(
          text: date,
          size: FontSize.s13,
        ),
      ],
    );
  }
}
