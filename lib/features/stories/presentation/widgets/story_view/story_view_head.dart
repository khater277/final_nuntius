import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_image.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/contact_story/story_date.dart';
import 'package:flutter/material.dart';

import '../../../../auth/data/models/user_data/user_data.dart';

class StoryViewHead extends StatelessWidget {
  const StoryViewHead({
    super.key,
    required this.stories,
    required this.user,
    required this.cubit,
  });

  final List<StoryModel> stories;
  final UserData user;
  final StoriesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppHeight.h10, horizontal: AppWidth.w5),
      child: Row(
        children: [
          UserImage(
            image: user.image!,
            isChat: true,
          ),
          SizedBox(width: AppWidth.w4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LargeHeadText(
                text: user == HiveHelper.getCurrentUser()
                    ? "My story"
                    : user.name!,
                size: FontSize.s14,
              ),
              SizedBox(height: AppHeight.h2),
              StoryDate(storyDate: stories[cubit.storyIndex].date!)
            ],
          ),
        ],
      ),
    );
  }
}
