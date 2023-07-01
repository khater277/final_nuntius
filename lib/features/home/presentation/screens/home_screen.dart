import 'package:final_nuntius/core/local_notifications/local_notifications_helper.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/home/presentation/widgets/app_nav_bar.dart';
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
    super.initState();
    NotificationsHelper.isAndroidPermissionGranted();
    NotificationsHelper.requestPermissions();
    NotificationsHelper.configureDidReceiveLocalNotificationSubject(context);
    NotificationsHelper.configureSelectNotificationSubject();
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
          ),
        );
      },
    );
  }
}
