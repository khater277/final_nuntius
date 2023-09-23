import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/contact_story_model/contact_story_model.dart';
import 'package:final_nuntius/features/stories/presentation/screens/story_view_screen.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/contact_story/story_date.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/stories/contact_story/story_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactStory extends StatefulWidget {
  final ContactStoryModel contactStoryModel;
  final bool isViewed;
  const ContactStory({
    Key? key,
    required this.contactStoryModel,
    required this.isViewed,
  }) : super(key: key);

  @override
  State<ContactStory> createState() => _ContactStoryState();
}

class _ContactStoryState extends State<ContactStory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCubit, StoriesState>(
      builder: (context, state) {
        final cubit = StoriesCubit.get(context);
        return state.maybeWhen(
          getContactsCurrentStoriesLoading: () => const Center(
            child: CustomCircleIndicator(),
          ),
          orElse: () => GestureDetector(
            onTap: () {
              cubit.openContactStory(
                  contactStoryModel: widget.contactStoryModel);
              Go.to(
                context: context,
                screen: StoryViewScreen(
                  stories: widget.contactStoryModel.stories!,
                  user: widget.contactStoryModel.user!,
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  StoryProfileImage(
                    image: widget.contactStoryModel.user!.image!,
                    isViewed: widget.isViewed,
                  ),
                  SizedBox(width: AppWidth.w8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LargeHeadText(
                        text: widget.contactStoryModel.user!.name!,
                        size: FontSize.s13,
                      ),
                      SizedBox(height: AppHeight.h1),
                      StoryDate(
                          storyDate:
                              widget.contactStoryModel.stories!.last.date!),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
