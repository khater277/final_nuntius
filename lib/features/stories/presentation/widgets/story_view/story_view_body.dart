import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/story_view/my_story_viewers/my_story_viewers.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/story_view/reply_to_story/reply_to_story.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryViewBody extends StatelessWidget {
  const StoryViewBody({
    super.key,
    required this.cubit,
    required this.stories,
    required this.myStory,
  });

  final StoriesCubit cubit;
  final List<StoryModel> stories;
  final bool myStory;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          StoryView(
              storyItems: cubit.storyItems,
              controller: cubit.storyController!,
              onStoryShow: (story) {
                final index = cubit.storyItems.indexOf(story);
                cubit.changeStoryIndex(index: index);
                final storyModel = stories[index];
                if (!storyModel.viewersPhones!
                        .contains(HiveHelper.getCurrentUser()!.phone) &&
                    cubit.contactStoryModel != null &&
                    !myStory) {
                  cubit.viewContactStory(
                    storyModel: storyModel,
                    phoneNumber: HiveHelper.getCurrentUser()!.phone!,
                  );
                }

                print("index=========>${cubit.storyIndex}");

                print("index=========>${cubit.storyItems.length}");
              },
              onComplete: () {
                debugPrint("COMPLETED");
                Go.back(context: context);
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Go.back(context: context);
                }
              }),
          if (myStory)
            MyStoryViewers(viewers: cubit.myStories[cubit.storyIndex].viewers!)
          else
            ReplyToStory(cubit: cubit),
          // ,
        ],
      ),
    );
  }
}
