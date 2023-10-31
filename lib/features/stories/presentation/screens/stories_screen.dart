import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/presentation/screens/add_media_story_screen.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/contact_story/current_stories.dart';
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
          getContactsCurrentStoriesError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
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
                      orElse: () => ContactCurrentStories(cubit: cubit),
                    ),
                  ],
                )));
      },
    );
  }
}
