import 'package:final_nuntius/core/firebase/fcm_helper.dart';
import 'package:final_nuntius/core/local_notifications/local_notifications_helper.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/home/presentation/widgets/app_nav_bar.dart';
import 'package:final_nuntius/features/home/presentation/widgets/stories_floating_buttons.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FcmHelper.handleForegroundNotification(
        homeCubit: HomeCubit.get(context), context: context);
    FcmHelper.handelBackgroundNotification(
        homeCubit: HomeCubit.get(context), context: context);
    NotificationsHelper.isAndroidPermissionGranted();
    NotificationsHelper.requestPermissions();
    NotificationsHelper.configureDidReceiveLocalNotificationSubject(context);
    NotificationsHelper.configureSelectNotificationSubject(
      ChatsCubit.get(context),
      context,
    );
    super.initState();
  }

  @override
  void dispose() {
    NotificationsHelper.didReceiveLocalNotificationStream.close();
    NotificationsHelper.selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return state.maybeMap(
          getContactsLoading: (value) => const Scaffold(
            extendBody: true,
            body: Center(
              child: CustomCircleIndicator(),
            ),
          ),
          orElse: () => Scaffold(
            body: cubit.screens[cubit.navBarIndex],
            extendBody: true,
            bottomNavigationBar: AppBottomNavBar(cubit: cubit),
            floatingActionButton: cubit.navBarIndex == 1
                ? BlocBuilder<StoriesCubit, StoriesState>(
                    builder: (context, state) {
                      final storiesCubit = StoriesCubit.get(context);
                      return StoriesFloatingButtons(storiesCubit: storiesCubit);
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
