import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/firebase/fcm_helper.dart';
import 'package:final_nuntius/core/local_notifications/local_notifications_helper.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/home/presentation/widgets/app_nav_bar.dart';
import 'package:final_nuntius/features/home/presentation/widgets/stories_fab.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/presentation/screens/add_text_story_screen.dart';
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
    FcmHelper.handleForegroundNotification(homeCubit: HomeCubit.get(context));
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
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
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
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StoriesFab(
                            onPressed: () {
                              Go.to(
                                  context: context,
                                  screen: const AddTextStoryScreen());
                            },
                            icon: IconBroken.Edit,
                            tag: "btn1",
                          ),
                          SizedBox(height: AppHeight.h6),
                          StoriesFab(
                            onPressed: () {
                              storiesCubit.pickStoryImage();
                            },
                            icon: IconBroken.Image,
                            tag: "btn2",
                          ),
                          SizedBox(height: AppHeight.h6),
                          StoriesFab(
                            onPressed: () {
                              storiesCubit.pickStoryVideo();
                            },
                            icon: IconBroken.Video,
                            tag: "btn3",
                          ),
                        ],
                      );
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
