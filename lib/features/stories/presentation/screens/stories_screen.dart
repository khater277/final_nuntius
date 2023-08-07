import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/screens/add_media_story_screen.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/contact_story/story_status.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/my_story/my_story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  void initState() {
    StoriesCubit.get(context).getStories(context);
    super.initState();
  }

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
    return BlocConsumer<StoriesCubit, StoriesState>(
      listener: (context, state) {
        state.maybeWhen(
          pickStoryImage: () => Go.to(
              context: context,
              screen:
                  const AddMediaStoryScreen(messageType: MessageType.image)),
          pickStoryVideo: () => Go.to(
              context: context,
              screen:
                  const AddMediaStoryScreen(messageType: MessageType.video)),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = StoriesCubit.get(context);
        return state.maybeWhen(
            pickStoryMediaLoading: () =>
                const Center(child: CustomCircleIndicator()),
            getMyStoriesLoading: () =>
                const Center(child: CustomCircleIndicator()),
            orElse: () => SliverScrollableView(
                hasScrollBody: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: AppHeight.h5),
                    MyStory(cubit: cubit),
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
                )));
      },
    );
  }
}
