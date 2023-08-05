import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/contact_story/contact_story.dart';
import 'package:flutter/material.dart';

class StoryStatus extends StatelessWidget {
  final List<StoryModel> storyList;
  final List<UserData> infoList;
  final bool isViewed;
  const StoryStatus(
      {Key? key,
      required this.storyList,
      required this.infoList,
      required this.isViewed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SmallHeadText(
          text: isViewed ? "Viewed stories" : "Recent stories",
          size: FontSize.s12,
          color: AppColors.grey,
        ),
        SizedBox(height: AppHeight.h2),
        Column(
          children: [
            for (int i = 0; i < infoList.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppHeight.h5),
                child: ContactStory(
                  userToken: infoList[i].token!,
                  userID: infoList[i].uId!,
                  name: infoList[i].name!,
                  image: infoList[i].image!,
                  storyDate: storyList[i].date!,
                  isViewed: isViewed,
                ),
              )
          ],
        ),
      ],
    );
  }
}
