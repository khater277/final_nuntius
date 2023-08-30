import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/stories/data/models/contact_story_model/contact_story_model.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/contact_story/contact_story.dart';
import 'package:flutter/material.dart';

class StoryStatus extends StatelessWidget {
  final List<ContactStoryModel> contactStories;
  final bool isViewed;
  const StoryStatus(
      {Key? key, required this.contactStories, required this.isViewed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SmallHeadText(
          text: isViewed ? "Viewed Stories" : "Recent stories",
          size: FontSize.s12,
          color: AppColors.grey,
        ),
        SizedBox(height: AppHeight.h2),
        Column(
          children: [
            for (int i = 0; i < contactStories.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppHeight.h5),
                child: Row(
                  children: [
                    ContactStory(
                      contactStoryModel: contactStories[i],
                      isViewed: isViewed,
                    ),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }
}
