import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/story_view/story_view_body.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/story_view/story_view_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final UserData user;
  const StoryViewScreen({super.key, required this.stories, required this.user});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  late StoriesCubit storiesCubit;
  @override
  void initState() {
    storiesCubit = StoriesCubit.get(context);
    storiesCubit.initStoryView(
      context: context,
    );
    super.initState();
  }

  @override
  void dispose() {
    storiesCubit.disposeStoryView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoriesCubit, StoriesState>(
      listener: (context, state) {
        state.maybeWhen(
          replyToStory: () => Go.back(context: context),
          replyToStoryError: (errorMsg) => showSnackBar(
            context: context,
            message: errorMsg,
            color: AppColors.red,
          ),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = StoriesCubit.get(context);

        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StoryViewHead(
                    stories: widget.stories, user: widget.user, cubit: cubit),
                StoryViewBody(
                  cubit: cubit,
                  stories: widget.stories,
                  myStory: widget.user.uId == HiveHelper.getCurrentUser()!.uId,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
