import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/my_story/add_my_story_profile_image.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/my_story/my_story_date.dart';
import 'package:flutter/material.dart';

class MyStory extends StatelessWidget {
  final String userToken;
  final String? image;
  final List<StoryModel> stories;
  const MyStory(
      {Key? key,
      required this.image,
      required this.stories,
      required this.userToken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (stories.isEmpty) {
        //   AppCubit.get(context).pickStoryImage();
        // } else {
        //   AppCubit.get(context).zeroStoryIndex();
        //   Get.to(() => StoryViewScreen(
        //         stories: stories,
        //         profileImage: image!,
        //         name: "My Story",
        //         userID: uId!,
        //         userToken: userToken,
        //         storiesIDs: null,
        //       ));
        // }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            AddMyStoryProfileImage(
              image: image,
              stories: stories,
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
                stories.isNotEmpty
                    ? MyStoryDate(stories: stories)
                    : SmallHeadText(
                        text: "tab to add stories update",
                        size: FontSize.s11,
                        color: AppColors.grey,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
