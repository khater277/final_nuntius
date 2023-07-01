import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/local_notifications/local_notifications_helper.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: false,
      expandedHeight: AppHeight.h30,
      flexibleSpace: Padding(
        padding: EdgeInsets.only(top: AppHeight.h20),
        child: FlexibleSpaceBar(
          background: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.w5),
                child: IconButton(
                    onPressed: () async {
                      await NotificationsHelper.showNotification(
                        id: 1,
                        name: 'Khater',
                        senderID: '123',
                      );
                      // Get.to(()=>const ProfileScreen());
                    },
                    icon: Icon(
                      IconBroken.Edit_Square,
                      size: AppSize.s20,
                      color: AppColors.grey,
                    )),
              ),
              Expanded(
                child: Center(
                  child: LargeHeadText(
                    text: "NUNTIUS",
                    letterSpacing: 2,
                    size: AppSize.s22,
                    color: AppColors.blue.withOpacity(0.7),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.w5),
                  child: IconButton(
                      onPressed: () {
                        Go.to(context: context, screen: const SearchScreen());
                      },
                      icon: Icon(
                        IconBroken.Search,
                        size: AppSize.s20,
                        color: AppColors.grey,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
