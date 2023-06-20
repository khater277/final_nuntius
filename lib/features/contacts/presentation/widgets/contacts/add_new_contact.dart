import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/contacts/presentation/screens/add_contact_screen.dart';
import 'package:flutter/material.dart';

class NewContact extends StatelessWidget {
  const NewContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Go.to(context: context, screen: const AddContactsScreen());
      },
      child: Row(
        children: [
          Container(
            width: AppWidth.w45,
            height: AppHeight.h40,
            decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(AppSize.s10)),
            child: Icon(
              IconBroken.Add_User,
              size: AppSize.s20,
            ),
          ),
          SizedBox(
            width: AppWidth.w8,
          ),
          LargeHeadText(
            text: "New contact",
            size: FontSize.s15,
          ),
        ],
      ),
    );
  }
}
