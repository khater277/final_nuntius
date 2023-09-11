import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/sliver_scrollable_view.dart';
import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
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
          orElse: () => SliverScrollableView(
            hasScrollBody: true,
            child: cubit.users.isEmpty
                ? const NoChatsFounded()
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

class NoChatsFounded extends StatelessWidget {
  const NoChatsFounded({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconBroken.Chat,
            size: AppSize.s100,
            color: AppColors.grey.withOpacity(0.4),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: AppWidth.w5),
              child: const SecondaryText(
                text:
                    "no chats founded , start now new chats with your friends.",
                maxLines: 10,
                center: true,
              )),
        ],
      ),
    );
  }
}
