import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/no_items_founded.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chats/chat_items.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    ChatsCubit.get(context).getChats(context);
    ChatsCubit.get(context).initChats(users: HomeCubit.get(context).users);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {
        state.maybeWhen(
          getChatsError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final ChatsCubit cubit = ChatsCubit.get(context);
        return state.maybeWhen(
          getChatsLoading: () => const Center(child: CustomCircleIndicator()),
          initChats: () => const Center(child: CustomCircleIndicator()),
          orElse: () => SliverScrollableView(
            isScrollable: cubit.users.isNotEmpty,
            child: cubit.users.isEmpty
                ? const NoItemsFounded(
                    text:
                        "no chats founded , start now new chats with your friends.",
                    icon: IconBroken.Chat,
                  )
                : ChatsItems(
                    users: cubit.users,
                    lastMessages: cubit.lastMessages,
                  ),
          ),
        );
      },
    );
  }
}
