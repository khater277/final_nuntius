import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/app_bar/messages_app_bar.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/day_date.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/message_bubble.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_text_field/message_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  final UserData user;
  final bool fromNotification;
  const MessagesScreen({
    super.key,
    required this.user,
    this.fromNotification = false,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late MessagesCubit messagesCubit;
  late HomeCubit homeCubit;
  late UserData userData;

  @override
  void initState() {
    userData = widget.user;
    messagesCubit = MessagesCubit.get(context);
    homeCubit = HomeCubit.get(context);
    messagesCubit.initMessages(user: widget.user, homeCubit: homeCubit);
    print("AAAAAAA777777777777777AAAAAAAAAAAAAAAAAAA");
    super.initState();
  }

  @override
  void dispose() {
    if (widget.fromNotification == false) {
      print("555555555555555555555555555555");
      messagesCubit.disposeMessages(homeCubit: homeCubit);
    }

    super.dispose();
  }

  // List<MessageModel> messages = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessagesCubit, MessagesState>(
      listener: (context, state) {
        state.maybeWhen(
          deleteMessage: () {
            Go.back(context: context);
            Go.back(context: context);
          },
          // getMessages: (messages) => this.messages = messages,
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = MessagesCubit.get(context);
        return state.maybeWhen(
            getMessagesLoading: () => const Scaffold(
                  body: Center(child: CustomCircleIndicator()),
                ),
            orElse: () => GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Scaffold(
                    appBar: messagesAppBar(name: cubit.user!.name!),
                    body: Padding(
                      padding: EdgeInsets.only(
                        top: AppHeight.h5,
                        right: AppWidth.w5,
                        left: AppWidth.w5,
                        // bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        // alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Expanded(
                            // height: double.infinity,
                            child: ListView.separated(
                              controller: cubit.scrollController!,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: cubit.messages.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Column(
                                children: [
                                  if (index == 0 ||
                                      DateFormat.yMMMEd().format(
                                            DateTime.parse(
                                                cubit.messages[index].date!),
                                          ) !=
                                          DateFormat.yMMMEd().format(
                                            DateTime.parse(cubit
                                                .messages[index - 1].date!),
                                          ))
                                    DayDate(date: cubit.messages[index].date!),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: MessageBubble(
                                          message: cubit.messages[index],
                                          isLastMessage: index ==
                                              cubit.messages.length - 1,
                                        ),
                                      ),
                                      if (state ==
                                              const MessagesState
                                                  .openDocMessageLoading() &&
                                          cubit.openedDocMessageId ==
                                              cubit.messages[index].messageId)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: AppWidth.w5),
                                          child: CustomCircleIndicator(
                                            size: AppSize.s18,
                                            strokeWidth: AppSize.s1,
                                          ),
                                        ),
                                    ],
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
                            loadingCondition: state ==
                                    const MessagesState.sendMessageLoading() ||
                                state ==
                                    const MessagesState.getFilePercentage(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
      },
    );
  }
}
