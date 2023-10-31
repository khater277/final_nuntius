import 'package:final_nuntius/core/shared_widgets/back_button.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';

AppBar editProfileAppBar(
    {required EditProfileCubit cubit, required EditProfileState state}) {
  return AppBar(
    titleSpacing: 0,
    leading: const CustomBackButton(),
    title: LargeHeadText(
      text: "Profile",
      color: AppColors.blue,
      size: FontSize.s17,
      letterSpacing: 1.5,
    ),
    actions: [
      if (cubit.profileImage != null)
        TextButton(
            onPressed: () => (state ==
                        const EditProfileState.updateProfileImageLoading() ||
                    state == const EditProfileState.getProfileImagePercentage())
                ? () {}
                : cubit.uploadProfileImage(),
            child: const Text(
              "UPLOAD",
              style: TextStyle(color: AppColors.white),
            ))
    ],
  );
}
