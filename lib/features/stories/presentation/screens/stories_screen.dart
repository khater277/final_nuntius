import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:flutter/material.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverScrollableView(
      hasScrollBody: false,
      child: Center(
        child: LargeHeadText(text: "Stories Screen"),
      ),
    );
  }
}
