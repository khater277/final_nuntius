import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayDate extends StatelessWidget {
  const DayDate({
    super.key,
    required this.date,
  });

  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: AppColors.lightBlack,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s20)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppHeight.h8,
              horizontal: AppWidth.w10,
            ),
            child: SmallHeadText(
              text: DateFormat.yMMMEd().format(
                DateTime.parse(date),
              ),
              color: AppColors.grey,
              size: FontSize.s11,
            ),
          ),
        ),
        SizedBox(height: AppHeight.h5),
      ],
    );
  }
}
