import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';

class MyProfileImage extends StatelessWidget {
  final String image;
  const MyProfileImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            if (EditProfileCubit.get(context).profileImage != null)
              CircleAvatar(
                radius: AppSize.s60,
                backgroundColor: AppColors.lightBlack,
                backgroundImage:
                    FileImage(EditProfileCubit.get(context).profileImage!),
              )
            else if (image.isNotEmpty)
              CircleAvatar(
                radius: AppSize.s60,
                backgroundColor: AppColors.lightBlack,
                backgroundImage: CachedNetworkImageProvider(image),
              )
            else
              CircleAvatar(
                radius: AppSize.s60,
                backgroundColor: AppColors.lightBlack,
                child: Icon(
                  IconBroken.Profile,
                  color: AppColors.blue,
                  size: AppSize.s60,
                ),
              ),
            GestureDetector(
              onTap: () async =>
                  EditProfileCubit.get(context).pickProfileImage(),
              child: CircleAvatar(
                radius: AppSize.s18,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Icon(
                  IconBroken.Camera,
                  color: AppColors.blue,
                  size: AppSize.s20,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
