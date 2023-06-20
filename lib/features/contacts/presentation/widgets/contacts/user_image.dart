import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final String image;
  final bool isChat;
  const UserImage({super.key, required this.image, this.isChat = false});

  @override
  Widget build(BuildContext context) {
    if (image == "") {
      return SizedBox(
        width: isChat ? AppWidth.w40 : AppWidth.w30,
        child: Icon(
          IconBroken.Profile,
          size: isChat ? AppSize.s30 : AppSize.s22,
          color: AppColors.blue,
        ),
      );
    } else {
      return SizedBox(
        width: isChat ? AppWidth.w40 : AppWidth.w30,
        child: CircleAvatar(
          radius: isChat ? AppSize.s25 : AppSize.s20,
          backgroundColor: AppColors.blue,
          backgroundImage: CachedNetworkImageProvider(image),
        ),
      );
    }
  }
}
