import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/contact_story/story_date.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/contact_story/story_profile_image.dart';
import 'package:flutter/material.dart';

class ContactStory extends StatelessWidget {
  final String name;
  final String image;
  final String storyDate;
  final String userID;
  final String userToken;
  final bool isViewed;
  const ContactStory(
      {Key? key,
      required this.image,
      required this.storyDate,
      required this.name,
      required this.userID,
      required this.isViewed,
      required this.userToken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // AppCubit.get(context).zeroStoryIndex();
        // Get.to(()=>StoryViewScreen(
        //   stories: stories,
        //   profileImage: image,
        //   name: name,
        //   userID: userID,
        //   storiesIDs: storiesIDs,
        //   userToken: userToken,
        // ));
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            StoryProfileImage(
              image: image,
              isViewed: isViewed,
            ),
            SizedBox(width: AppWidth.w8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LargeHeadText(
                  text: name,
                  size: FontSize.s13,
                ),
                SizedBox(height: AppHeight.h1),
                StoryDate(storyDate: storyDate),
              ],
            )
          ],
        ),
      ),
    );
  }
}
