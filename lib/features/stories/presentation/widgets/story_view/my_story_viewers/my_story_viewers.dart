import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/data/models/viewer_model/viewer_model.dart';
import 'package:flutter/material.dart';

class MyStoryViewers extends StatelessWidget {
  final List<Map<String, dynamic>> viewers;

  const MyStoryViewers({Key? key, required this.viewers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        StoriesCubit.get(context)
            .showStoryViewers(context: context, viewers: viewers);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: AppHeight.h5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.visibility_outlined,
              color: AppColors.grey,
              size: AppSize.s20,
            ),
            LargeHeadText(
              text: " ${viewers.length}",
              size: FontSize.s12,
            ),
          ],
        ),
      ),
    );
  }
}
