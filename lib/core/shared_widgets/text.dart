import 'package:flutter/material.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';

class LargeHeadText extends StatelessWidget {
  final String text;
  final double? size;
  final bool isEllipsis;
  final int maxLines;
  final Color? color;
  const LargeHeadText(
      {super.key,
      required this.text,
      this.size,
      this.isEllipsis = true,
      this.maxLines = 1,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: size ?? FontSize.s16,
            color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
          ),
      maxLines: maxLines,
      overflow: isEllipsis ? TextOverflow.ellipsis : null,
    );
  }
}

class SmallHeadText extends StatelessWidget {
  final String text;
  final double? size;
  final bool isEllipsis;
  final int maxLines;
  final Color? color;
  const SmallHeadText(
      {super.key,
      required this.text,
      this.size,
      this.isEllipsis = true,
      this.maxLines = 1,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: size ?? FontSize.s14,
            color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
          ),
      maxLines: maxLines,
      overflow: isEllipsis ? TextOverflow.ellipsis : null,
    );
  }
}

class PrimaryText extends StatelessWidget {
  final String text;
  final bool center;
  final double? size;
  final bool isEllipsis;
  const PrimaryText(
      {super.key,
      required this.text,
      this.size,
      this.center = false,
      this.isEllipsis = true});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontSize: size ?? FontSize.s14,
          ),
      textAlign: center ? TextAlign.center : null,
      overflow: isEllipsis ? TextOverflow.ellipsis : null,
    );
  }
}

class PrimaryWithStaticColorText extends StatelessWidget {
  final String text;
  final bool center;
  final double? size;
  final FontWeight? fontWeight;
  const PrimaryWithStaticColorText(
      {super.key,
      required this.text,
      this.size,
      this.center = false,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
          fontSize: size ?? FontSize.s14,
          color: AppColors.white,
          fontWeight: fontWeight),
      textAlign: center ? TextAlign.center : null,
    );
  }
}

class SecondaryText extends StatelessWidget {
  final String text;
  final bool center;
  final double? size;
  final bool isLight;
  final bool isButton;
  final bool isEllipsis;
  final int? maxLines;
  final Color? color;
  const SecondaryText({
    super.key,
    required this.text,
    this.size,
    this.center = false,
    this.isLight = false,
    this.isButton = false,
    this.isEllipsis = true,
    this.maxLines,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: size ?? FontSize.s14,
          fontWeight: isButton ? FontWeightManager.semiBold : null,
          color: color ??
              (isLight
                  ? Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .color!
                      .withOpacity(0.8)
                  : null)),
      textAlign: center ? TextAlign.center : null,
      overflow: isEllipsis ? TextOverflow.ellipsis : null,
      maxLines: maxLines,
    );
  }
}

class TealText extends StatelessWidget {
  final String text;
  final bool center;
  final double? size;
  final bool isEllipsis;
  const TealText(
      {super.key,
      required this.text,
      this.size,
      this.center = false,
      this.isEllipsis = true});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.blue,
            fontSize: size ?? FontSize.s14,
          ),
      textAlign: center ? TextAlign.center : null,
      overflow: isEllipsis ? TextOverflow.ellipsis : null,
    );
  }
}