import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/stories/presentation/screens/delete_stories_screen.dart';
import 'package:flutter/material.dart';

class EditMyStories extends StatelessWidget {
  const EditMyStories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Go.to(context: context, screen: const DeleteStoriesScreen()),
      child: Icon(
        IconBroken.Setting,
        color: AppColors.blue,
        size: AppSize.s16,
      ),
    );
  }
}
