import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final String image;
  const UserImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    if (image == "") {
      return SizedBox(
        width: AppWidth.w30,
        child: Icon(
          IconBroken.Profile,
          size: AppSize.s22,
          color: AppColors.blue,
        ),
      );
    } else {
      return SizedBox(
        width: AppWidth.w30,
        child: CircleAvatar(
          radius: AppSize.s20,
          backgroundColor: AppColors.blue,
          backgroundImage: CachedNetworkImageProvider(image),
        ),
      );
    }
  }
}
