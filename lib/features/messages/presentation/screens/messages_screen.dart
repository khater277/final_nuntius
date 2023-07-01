import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/app_bar/messages_app_bar.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/day_date.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_text_field/message_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  final UserData user;
  const MessagesScreen({super.key, required this.user});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late MessagesCubit messagesCubit;

  @override
  void initState() {
    messagesCubit = MessagesCubit.get(context);
    messagesCubit.initMessages(user: widget.user);
    super.initState();
  }

  @override
  void dispose() {
    messagesCubit.disposeMessages();
    super.dispose();
  }

  List<MessageModel> messages = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessagesCubit, MessagesState>(
      listener: (context, state) {
        state.maybeWhen(
          getMessages: (messages) => this.messages = messages,
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = MessagesCubit.get(context);
        return state.maybeWhen(
            getMessagesLoading: () => const Scaffold(
                  body: Center(child: CustomCircleIndicator()),
                ),
            orElse: () => Scaffold(
                  appBar: messagesAppBar(name: cubit.user!.name!),
                  body: Padding(
                    padding: EdgeInsets.only(
                      top: AppHeight.h5,
                      right: AppWidth.w5,
                      left: AppWidth.w5,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        SizedBox(
                          height: double.infinity,
                          child: ListView.separated(
                            controller: cubit.scrollController!,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              children: [
                                if (index == 0 ||
                                    DateFormat.yMMMEd().format(
                                          DateTime.parse(messages[index].date!),
                                        ) !=
                                        DateFormat.yMMMEd().format(
                                          DateTime.parse(
                                              messages[index - 1].date!),
                                        ))
                                  DayDate(date: messages[index].date!),
                                MessageBubble(
                                  message: messages[index],
                                  isLastMessage: index == messages.length - 1,
                                ),
                              ],
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                              height: AppHeight.h8,
                            ),
                          ),
                        ),
                        SendMessageTextField(
                          loadingCondition:
                              state == const MessagesState.sendMessageLoading(),
                        ),
                      ],
                    ),
                  ),
                ));
      },
    );
  }
}
