import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:flutter/material.dart';

class UserNameAndPhoneNumber extends StatelessWidget {
  final UserData user;
  const UserNameAndPhoneNumber({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LargeHeadText(text: user.name!),
          SizedBox(height: AppHeight.h1),
          SecondaryText(
            text: "${user.phone}",
            size: FontSize.s13,
          ),
        ],
      ),
    );
  }
}
