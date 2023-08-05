import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/contact_story/story_status.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/my_story/my_story.dart';
import 'package:flutter/material.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<StoryModel> recentStories = [
      StoryModel(
        date: DateTime.now().toString(),
        phone: HiveHelper.getCurrentUser()!.phone,
        text: "AHMED KHATER",
      ),
      StoryModel(
        date: DateTime.now().toString(),
        phone: HiveHelper.getCurrentUser()!.phone,
        text: "AHMED KHATER",
      ),
    ];
    List<StoryModel> viewedStories = [
      StoryModel(
        date: DateTime.now().toString(),
        phone: HiveHelper.getCurrentUser()!.phone,
        text: "AHMED KHATER",
      ),
      StoryModel(
        date: DateTime.now().toString(),
        phone: HiveHelper.getCurrentUser()!.phone,
        text: "AHMED KHATER",
      ),
    ];
    List<UserData> viewedInfo = [
      HiveHelper.getCurrentUser()!,
      HiveHelper.getCurrentUser()!,
    ];
    List<UserData> recentInfo = [
      HiveHelper.getCurrentUser()!,
      HiveHelper.getCurrentUser()!,
    ];
    return SliverScrollableView(
        hasScrollBody: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppHeight.h5),
            MyStory(
              userToken: "cubit.userModel!.token!",
              image: "",
              stories: [
                StoryModel(
                  date: DateTime.now().toString(),
                  phone: HiveHelper.getCurrentUser()!.phone,
                  text: "AHMED KHATER",
                )
              ],
            ),
            SizedBox(height: AppHeight.h5),
            Divider(
              color: AppColors.grey.withOpacity(0.3),
            ),
            SizedBox(height: AppHeight.h5),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: [
                  if (recentStories.isNotEmpty)
                    StoryStatus(
                      storyList: recentStories,
                      infoList: recentInfo,
                      isViewed: false,
                    ),
                  if (viewedStories.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: AppHeight.h10),
                        StoryStatus(
                          storyList: viewedStories,
                          infoList: viewedInfo,
                          isViewed: true,
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ));
  }
}
