import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/no_items_founded.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/chats/presentation/widgets/chat_builder.dart';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {
        // state.maybeWhen(
        //   getChats: (lastMessages, users) {
        //     this.lastMessages = lastMessages;
        //     this.users = users;
        //   },
        //   orElse: () {},
        // );
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
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ChatBuilder(
                                user: cubit.users[index],
                                lastMessage: cubit.lastMessages[index],
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                                  color: AppColors.grey.withOpacity(0.08),
                                ),
                            itemCount: cubit.users.length),
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}
