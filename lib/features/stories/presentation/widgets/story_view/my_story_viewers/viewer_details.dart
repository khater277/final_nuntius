import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_functions.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_image.dart';
import 'package:flutter/material.dart';

class ViewerDetails extends StatelessWidget {
  final UserData user;
  final String viewDateTime;
  const ViewerDetails(
      {Key? key, required this.user, required this.viewDateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool condition = DateTime.parse(viewDateTime).day == DateTime.now().day;

    return Row(
      children: [
        UserImage(
          image: user.image!,
        ),
        SizedBox(width: AppWidth.w5),
        Expanded(
          child: LargeHeadText(
            text: "${user.name}",
            size: FontSize.s13,
          ),
        ),
        SizedBox(width: AppWidth.w5),
        SmallHeadText(
          text: AppFunctions.storyDate(viewDateTime),
          size: FontSize.s11,
        ),
        SizedBox(width: AppWidth.w6),
      ],
    );
  }
}
