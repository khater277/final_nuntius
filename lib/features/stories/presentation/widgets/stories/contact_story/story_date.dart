import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_functions.dart';
import 'package:flutter/material.dart';

class StoryDate extends StatelessWidget {
  final String storyDate;
  const StoryDate({Key? key, required this.storyDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream stream = Stream.periodic(const Duration(seconds: 1), (a) => a);
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          String date = AppFunctions.storyDate(storyDate);
          return SmallHeadText(
            text: date,
            color: AppColors.grey,
            size: FontSize.s11,
          );
        });
  }
}
