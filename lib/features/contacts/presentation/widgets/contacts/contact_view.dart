import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_image.dart';
import 'package:final_nuntius/features/contacts/presentation/widgets/contacts/user_name_and_phone_number.dart';
import 'package:flutter/material.dart';

class ContactView extends StatelessWidget {
  final UserData user;
  final bool fromSearch;
  const ContactView({Key? key, required this.user, this.fromSearch = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppHeight.h10),
      child: GestureDetector(
        onTap: () {
          // Get.to(()=>MessagesScreen(
          //   user: user,
          //   isFirstMessage: true,
          // ));
        },
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              UserImage(image: user.image!),
              SizedBox(
                width: AppWidth.w10,
              ),
              UserNameAndPhoneNumber(user: user),
              SizedBox(
                width: AppWidth.w10,
              ),
              if (!fromSearch)
                Icon(
                  IconBroken.Arrow___Right_2,
                  size: AppSize.s18,
                  color: Colors.grey,
                )
            ],
          ),
        ),
      ),
    );
  }
}
