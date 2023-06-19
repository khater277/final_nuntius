import 'package:flutter/material.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_functions.dart';
import 'package:final_nuntius/core/utils/app_values.dart';

class FlagAndCountryCode extends StatelessWidget {
  const FlagAndCountryCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: AppHeight.h13, horizontal: AppWidth.w8),
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        // border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      child: SmallHeadText(
        text: "${AppFunctions.generateCountryFlag(countryCode: 'eg')}  +20",
      ),
    );
  }
}
