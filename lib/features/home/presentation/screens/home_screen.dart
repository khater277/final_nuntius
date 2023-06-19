import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LargeHeadText(text: "HOME")),
    );
  }
}
