import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/edit_profile/presentation/widgets/edit_my_name.dart';
import 'package:flutter/material.dart';

class MyName extends StatelessWidget {
  final String name;

  const MyName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppHeight.h4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            IconBroken.Profile,
            size: AppSize.s20,
            color: AppColors.grey,
          ),
          SizedBox(width: AppWidth.w10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LargeHeadText(
                    text: "Name", size: FontSize.s13, color: AppColors.white),
                SizedBox(height: AppHeight.h1),
                LargeHeadText(
                    text: HiveHelper.getCurrentUser()!.name!,
                    size: FontSize.s13,
                    color: Colors.blue),
                SizedBox(height: AppHeight.h2),
                LargeHeadText(
                  text:
                      "This is not your username or pin. This name will be visible to your NUNTIUS contacts",
                  size: FontSize.s10,
                  color: Colors.grey,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          EditMyName(name: name),
        ],
      ),
    );
  }
}
