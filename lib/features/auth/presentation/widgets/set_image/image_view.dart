import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_images.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final AuthCubit cubit;
  const ImageView({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        CircleAvatar(
          radius: AppSize.s60,
          backgroundImage: cubit.profileImage != null
              ? FileImage(cubit.profileImage!)
              : HiveHelper.getCurrentUser() != null &&
                      HiveHelper.getCurrentUser()!.image != ""
                  ? NetworkImage(HiveHelper.getCurrentUser()!.image!)
                      as ImageProvider
                  : const AssetImage(
                      AppImages.user,
                    ),
          backgroundColor: AppColors.lightBlack,
        ),
        CircleAvatar(
          radius: AppSize.s15,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: GestureDetector(
            onTap: () {
              cubit.pickProfileImage();
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: AppHeight.h1),
              child: Icon(
                IconBroken.Camera,
                color: AppColors.blue,
                size: AppSize.s20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
