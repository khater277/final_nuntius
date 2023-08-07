import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/story_view/story_view_body.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/story_view/story_view_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  const StoryViewScreen({super.key, required this.stories});

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
      stories: widget.stories,
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
                StoryViewHead(stories: widget.stories, cubit: cubit),
                StoryViewBody(cubit: cubit),
              ],
            ),
          ),
        );
      },
    );
  }
}
