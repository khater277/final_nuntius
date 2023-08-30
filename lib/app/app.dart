import 'package:final_nuntius/app/injector.dart';
import 'package:final_nuntius/config/app_theme.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/features/auth/cubit/auth_cubit.dart';
import 'package:final_nuntius/features/auth/presentation/screens/login_screen.dart';
import 'package:final_nuntius/features/calls/cubit/calls_cubit.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/contacts/cubit/contacts_cubit.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/home/presentation/screens/home_screen.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/search/cubit/search_cubit.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                create: (BuildContext context) =>
                    di<HomeCubit>()..getContacts(),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    di<ChatsCubit>()..initChats(context)
                // ..getChats(context)
                ,
              ),
              BlocProvider(
                create: (BuildContext context) => di<StoriesCubit>()
                  ..getPhones(
                    HomeCubit.get(context).phones.keys.toList(),
                    HomeCubit.get(context).users,
                  )
                  ..getContactsCurrentStories(
                      users: HomeCubit.get(context).users),
              ),
              BlocProvider(
                create: (BuildContext context) => di<CallsCubit>(),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    di<ContactsCubit>()..getContacts(context),
              ),
              BlocProvider(
                create: (BuildContext context) => di<MessagesCubit>(),
              ),
              BlocProvider(
                create: (BuildContext context) => di<SearchCubit>(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme(),
              home:
                  // const LoginScreen(),
                  HiveHelper.getCurrentUser() == null
                      ? const LoginScreen()
                      : const HomeScreen(),
            ),
          );
        });
  }
}
