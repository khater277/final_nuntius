import 'package:final_nuntius/core/shared_widgets/sliver_app_bar.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:flutter/material.dart';

class SliverScrollableView extends StatelessWidget {
  final bool hasScrollBody;
  final Widget child;
  const SliverScrollableView(
      {super.key, required this.hasScrollBody, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const CustomSliverAppBar(),
        SliverFillRemaining(
          hasScrollBody: hasScrollBody,
          child: Padding(
            padding: EdgeInsets.only(
              right: AppWidth.w10,
              left: AppWidth.w10,
              top: AppHeight.h5,
            ),
            child: child,
          ),
        )
      ],
    );
  }
}
