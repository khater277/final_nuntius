import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:flutter/material.dart';

class MyPhoneNumber extends StatelessWidget {
  final String phone;
  const MyPhoneNumber({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            IconBroken.Call,
            size: AppSize.s20,
            color: AppColors.grey,
          ),
          SizedBox(width: AppWidth.w10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LargeHeadText(
                    text: "Phone number",
                    size: FontSize.s13,
                    color: Colors.white),
                SizedBox(height: AppHeight.h1),
                LargeHeadText(
                    text: HiveHelper.getCurrentUser()!.phone!,
                    size: FontSize.s12,
                    color: AppColors.blue),
              ],
            ),
          ),
          // Icon(IconBroken.Edit,size: 16.sp,color: AppColors.grey,),
        ],
      ),
    );
  }
}
