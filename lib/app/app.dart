import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_nuntius/app/injector.dart';
import 'package:final_nuntius/config/app_theme.dart';
import 'package:final_nuntius/core/local_notifications/local_notifications_helper.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/auth/presentation/screens/login_screen.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 667),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) => di<AuthCubit>(),
              ),
              BlocProvider(
                create: (BuildContext context) => di<CallsCubit>(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme(),
              home: const LoginScreen(),
            ),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return BlocConsumer<CallsCubit, CallsState>(
      listener: (context, state) {
        state.maybeWhen(
          generateTokenSuccess: (token) => showSnackBar(
              context: context, message: token, color: AppColors.blue),
          generateTokenError: (errorMsg) => showSnackBar(
              context: context, message: errorMsg, color: AppColors.lightRed),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final CallsCubit cubit = CallsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text("widget.title"),
          ),
          body: Center(
            child: TextButton(
              onPressed: () {
                cubit.generateToken();
                // NotificationsHelper.showNotification(
                //   id: 1,
                //   name: "name",
                //   senderID: "senderID",
                // );
              },
              child: (const Text("PRESS")),
            ),
          ),
        );
      },
    );
  }
}
