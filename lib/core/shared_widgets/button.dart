import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/font_styles.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? fillColor;
  final Color? textColor;
  final double? textSize;
  final bool setShadow;
  final bool loadingCondition;
  final IconData? icon;
  final double? borderRadius;

  const CustomButton(
      {Key? key,
      required this.text,
      this.fillColor,
      this.textColor,
      this.textSize,
      this.setShadow = false,
      this.loadingCondition = false,
      this.icon,
      this.borderRadius,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loadingCondition ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: fillColor,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(borderRadius ?? AppSize.s20))),
      child: loadingCondition
          ? const CustomCircleIndicator(color: Colors.black)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Row(
                    children: [
                      FaIcon(
                        icon,
                        color: AppColors.black,
                      ),
                      SizedBox(width: AppWidth.w6),
                    ],
                  ),
                Text(
                  text,
                  style: getSemiBoldStyle(
                    fontSize: textSize ?? FontSize.s14,
                    fontColor: textColor ?? AppColors.black,
                  ),
                ),
              ],
            ),
    );
  }
}
