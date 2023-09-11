import 'package:final_nuntius/core/utils/app_images.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:flutter/material.dart';

class StoryImage extends StatelessWidget {
  const StoryImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: SizedBox(
          width: AppSize.s30,
          height: AppSize.s30,
          child: Image.asset(AppImages.user),
        ),
      ),
    );
  }
}
