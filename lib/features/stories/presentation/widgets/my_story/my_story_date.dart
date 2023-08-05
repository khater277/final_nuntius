import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_functions.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:flutter/material.dart';

class MyStoryDate extends StatelessWidget {
  final List<StoryModel> stories;
  const MyStoryDate({Key? key, required this.stories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream stream = Stream.periodic(const Duration(seconds: 1), (a) => a);
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          String date =
              AppFunctions.storyDate(stories[stories.length - 1].date!);
          // DateFormatter().storyDate(stories[stories.length - 1].date!);
          return SmallHeadText(
            text: date,
            color: AppColors.grey,
            size: FontSize.s11,
          );
        });
  }
}
