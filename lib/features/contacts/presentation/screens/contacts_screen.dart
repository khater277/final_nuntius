import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LargeHeadText(text: "Contacts Screen")),
    );
  }
}
