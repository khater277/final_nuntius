import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/presentation/screens/story_view_screen.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/my_story/add_my_story_profile_image.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/my_story/my_story_date.dart';
import 'package:flutter/material.dart';

class MyStory extends StatelessWidget {
  final StoriesCubit cubit;
  const MyStory({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cubit.myStories.isNotEmpty) {
          // cubit.open
          Go.to(
              context: context,
              screen: StoryViewScreen(
                stories: cubit.myStories,
                user: HiveHelper.getCurrentUser()!,
              ));
        } else {
          cubit.pickStoryImage();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            AddMyStoryProfileImage(
              image: HiveHelper.getCurrentUser()!.image,
              stories: cubit.myStories,
            ),
            SizedBox(width: AppWidth.w10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LargeHeadText(
                  text: "My story",
                  size: FontSize.s14,
                ),
                SizedBox(height: AppHeight.h2),
                cubit.myStories.isNotEmpty
                    ? MyStoryDate(stories: cubit.myStories)
                    : SmallHeadText(
                        text: "tab to add stories update",
                        size: FontSize.s11,
                        color: AppColors.grey,
                      ),
              ],
            ),
            Expanded(
              child: LargeHeadText(
                text: "${cubit.contactsStories.length}",
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
