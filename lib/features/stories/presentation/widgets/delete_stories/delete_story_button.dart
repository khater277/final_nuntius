import 'package:final_nuntius/core/shared_widgets/alert_dialog.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/story_model/story_model.dart';
import 'package:flutter/material.dart';

class DeleteStoryButton extends StatelessWidget {
  const DeleteStoryButton({
    super.key,
    required this.storyModel,
    required this.loadingCondition,
  });

  final StoryModel storyModel;
  final bool loadingCondition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAlertDialog(
          context: context,
          text: "Are you sure you want to delete this story?",
          okPressed: () =>
              StoriesCubit.get(context).deleteStory(storyId: storyModel.id!),
          loadingCondition: loadingCondition,
        );
      },
      child: Icon(
        IconBroken.Delete,
        size: AppSize.s17,
        color: AppColors.blue,
      ),
    );
  }
}
