import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final HomeCubit cubit;
  const AppBottomNavBar({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.h3),
      child: DotNavigationBar(
        curve: Curves.fastOutSlowIn,
        currentIndex: cubit.navBarIndex,
        onTap: (index) {
          cubit.changeNavBar(index: index);
        },
        marginR: EdgeInsets.symmetric(horizontal: AppWidth.w20)
            .add(EdgeInsets.only(bottom: AppHeight.h2)),
        dotIndicatorColor: Colors.transparent,
        selectedItemColor: AppColors.blue,
        unselectedItemColor: AppColors.white.withOpacity(0.7),
        backgroundColor: AppColors.lightBlack,
        itemPadding: EdgeInsets.only(
          left: AppWidth.w20,
          right: AppWidth.w20,
          top: AppHeight.h5,
        ),
        borderRadius: AppSize.s50,
        items: [
          DotNavigationBarItem(
            icon: Icon(
              IconBroken.Chat,
              size: AppSize.s20,
            ),
          ),
          DotNavigationBarItem(
            icon: Icon(
              IconBroken.Camera,
              size: AppSize.s20,
            ),
          ),
          DotNavigationBarItem(
            icon: Icon(
              IconBroken.Call,
              size: AppSize.s20,
            ),
          ),
          DotNavigationBarItem(
            icon: Icon(
              IconBroken.User1,
              size: AppSize.s20,
            ),
          ),
        ],
      ),
    );
  }
}
