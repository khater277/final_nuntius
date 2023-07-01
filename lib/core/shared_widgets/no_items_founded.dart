import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:flutter/material.dart';

class NoItemsFounded extends StatelessWidget {
  final String text;
  final IconData icon;
  const NoItemsFounded({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: AppSize.s100,
          color: AppColors.grey.withOpacity(0.4),
        ),
        SizedBox(
          height: AppHeight.h4,
        ),
        SecondaryText(
          text: text,
          size: FontSize.s13,
        ),
      ],
    );
  }
}
