import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/calls/presentation/screens/video_call_screen.dart';
import 'package:final_nuntius/features/calls/presentation/screens/voice_call_screen.dart';
import 'package:final_nuntius/features/chats/cubit/chats_cubit.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/messages/cubit/messages_cubit.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/app_bar/messages_app_bar.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/day_date.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_bubble/message_bubble.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/message_text_field/message_text_field.dart';
import 'package:final_nuntius/features/messages/presentation/widgets/scroll_down_button.dart';
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
  ValueNotifier<bool> showScrollDownButton = ValueNotifier<bool>(false);

  @override
  void initState() {
    userData = widget.user;
    messagesCubit = MessagesCubit.get(context);
    homeCubit = HomeCubit.get(context);
    messagesCubit.initMessages(
      homeCubit: homeCubit,
      user: widget.user,
      phoneNumber: widget.user.phone!,
    );
    MessagesCubit.get(context)
        .readMessage(lastMessages: ChatsCubit.get(context).lastMessages);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.fromNotification == false) {
      messagesCubit.disposeMessages(homeCubit: homeCubit);
    }
    super.dispose();
  }

  void goToCallScreen(BuildContext context, String rtcToken, String channelName,
      CallType callType) {
    if (callType == CallType.voice) {
      Go.to(
        context: context,
        screen: VoiceCallScreen(
          userToken: MessagesCubit.get(context).user!.token!,
          rtcToken: rtcToken,
          channelName: channelName,
          image: MessagesCubit.get(context).user!.image!,
          name: MessagesCubit.get(context).user!.name!,
          phoneNumber: MessagesCubit.get(context).user!.phone!,
        ),
      );
    } else {
      Go.to(
        context: context,
        screen: VideoCallScreen(
          userToken: MessagesCubit.get(context).user!.token!,
          rtcToken: rtcToken,
          channelName: channelName,
          image: MessagesCubit.get(context).user!.image!,
          name: MessagesCubit.get(context).user!.name!,
          phoneNumber: MessagesCubit.get(context).user!.phone!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessagesCubit, MessagesState>(
      listener: (context, state) {
        state.maybeWhen(
          deleteMessage: () {
            Go.back(context: context);
            Go.back(context: context);
          },
          generateToken: (rtcToken, channelName, callType) {
            goToCallScreen(context, rtcToken, channelName, callType);
          },
          generateTokenError: (errorMsg) => errorSnackBar(
              context: context,
              errorMsg: "$errorMsg , please check agora token server."),
          sendMessageError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          deleteMessageError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          openDocMessageError: (errorMsg) =>
              errorSnackBar(context: context, errorMsg: errorMsg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = MessagesCubit.get(context);
        return state.maybeWhen(
            getMessagesLoading: () => const Scaffold(
                  body: Center(child: CustomCircleIndicator()),
                ),
            orElse: () => WillPopScope(
                  onWillPop: () async {
                    cubit.readMessage(
                        lastMessages: ChatsCubit.get(context).lastMessages);
                    return true;
                  },
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Scaffold(
                      appBar: messagesAppBar(name: cubit.user!.name!),
                      body: Padding(
                        padding: EdgeInsets.only(
                          top: AppHeight.h5,
                          right: AppWidth.w5,
                          left: AppWidth.w5,
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: showScrollDownButton,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return NotificationListener(
                              onNotification: (notification) {
                                if (notification is ScrollEndNotification) {
                                  if (cubit.scrollController!.position
                                          .minScrollExtent !=
                                      cubit.scrollController!.position.pixels) {
                                    showScrollDownButton.value = true;
                                    print(
                                        "=================>${showScrollDownButton.value}");
                                  } else {
                                    showScrollDownButton.value = false;
                                  }
                                }
                                return true;
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ListView.separated(
                                          controller: cubit.scrollController!,
                                          reverse: true,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: cubit.messages.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              Column(
                                            children: [
                                              if (index ==
                                                      cubit.messages.length -
                                                          1 ||
                                                  DateFormat.yMMMEd().format(
                                                        DateTime.parse(cubit
                                                            .messages[index]
                                                            .date!),
                                                      ) !=
                                                      DateFormat.yMMMEd()
                                                          .format(
                                                        DateTime.parse(cubit
                                                            .messages[index + 1]
                                                            .date!),
                                                      ))
                                                DayDate(
                                                    date: cubit
                                                        .messages[index].date!),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: MessageBubble(
                                                      message:
                                                          cubit.messages[index],
                                                      isLastMessage: index ==
                                                          cubit.messages
                                                                  .length -
                                                              1,
                                                      loadingCondition: state ==
                                                          MessagesState
                                                              .deleteMessageLoading(
                                                                  cubit
                                                                      .messages[
                                                                          index]
                                                                      .messageId!),
                                                    ),
                                                  ),
                                                  if (state ==
                                                          const MessagesState
                                                              .openDocMessageLoading() &&
                                                      cubit.openedDocMessageId ==
                                                          cubit.messages[index]
                                                              .messageId)
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  AppWidth.w5),
                                                      child:
                                                          CustomCircleIndicator(
                                                        size: AppSize.s18,
                                                        strokeWidth: AppSize.s1,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              if (0 == index)
                                                SizedBox(height: AppHeight.h5),
                                            ],
                                          ),
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  SizedBox(
                                            height: AppHeight.h8,
                                          ),
                                        ),
                                        if (showScrollDownButton.value)
                                          ScrollDownButton(
                                              receiveMessage: state ==
                                                  const MessagesState
                                                      .receiveMessage())
                                      ],
                                    ),
                                  ),
                                  SendMessageTextField(
                                    loadingCondition: state ==
                                            const MessagesState
                                                .sendMessageLoading() ||
                                        state ==
                                            const MessagesState
                                                .getFilePercentage(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ));
      },
    );
  }
}
