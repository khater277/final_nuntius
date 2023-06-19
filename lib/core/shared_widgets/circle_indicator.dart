import 'package:flutter/material.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';

class CustomCircleIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? strokeWidth;
  const CustomCircleIndicator(
      {super.key, this.size, this.color, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? AppSize.s30,
      height: size ?? AppSize.s30,
      child: CircularProgressIndicator(
        color: color ?? AppColors.blue,
        strokeWidth: strokeWidth ?? AppSize.s2,
      ),
    );
  }
}
