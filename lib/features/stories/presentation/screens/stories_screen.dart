import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/no_items_founded.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
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
    StoriesCubit.get(context).getStories(context: context);
    StoriesCubit.get(context).contactsStoriesChanged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoriesCubit, StoriesState>(
      listener: (context, state) {
        state.maybeWhen(
          getContactsCurrentStoriesError: (errorMsg) => showSnackBar(
            context: context,
            message: errorMsg,
            color: AppColors.red,
          ),
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
            getContactsCurrentStoriesLoading: () =>
                const Center(child: CustomCircleIndicator()),
            orElse: () => SliverScrollableView(
                isScrollable: cubit.viewedStories.isNotEmpty ||
                    cubit.recentStories.isNotEmpty,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: AppHeight.h5),
                    MyStory(cubit: cubit),
                    SizedBox(height: AppHeight.h5),
                    Divider(color: AppColors.grey.withOpacity(0.3)),
                    SizedBox(height: AppHeight.h5),
                    state.maybeWhen(
                      getContactsCurrentStoriesLoading: () =>
                          const Center(child: CustomCircleIndicator()),
                      orElse: () => CurrentStories(cubit: cubit),
                      // CurrentStories(cubit: cubit),
                    ),
                  ],
                )));
      },
    );
  }
}

class CurrentStories extends StatelessWidget {
  const CurrentStories({
    super.key,
    required this.cubit,
  });

  final StoriesCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit.recentStories.isEmpty && cubit.viewedStories.isEmpty) {
      return const Expanded(
        child: NoItemsFounded(
          text: "There is no stories to show yet.",
          icon: IconBroken.Camera,
        ),
      );
    } else {
      return Flexible(
        fit: FlexFit.loose,
        child: Column(
          children: [
            if (cubit.recentStories.isNotEmpty)
              StoryStatus(
                contactStories: cubit.recentStories,
                isViewed: false,
              ),
            if (cubit.viewedStories.isNotEmpty)
              // LargeHeadText(text: cubit.viewedStories.first.stories!.length.toString())
              Column(
                children: [
                  StoryStatus(
                    contactStories: cubit.viewedStories,
                    isViewed: true,
                  ),
                ],
              ),
          ],
        ),
      );
    }
  }
}
