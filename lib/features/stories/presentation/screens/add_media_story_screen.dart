import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/shared_widgets/circle_indicator.dart';
import 'package:final_nuntius/core/shared_widgets/snack_bar.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/add_media_story/Image_story.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/add_media_story/caption_text_field.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/add_media_story/video_story.dart';
import 'package:final_nuntius/features/stories/presentation/widgets/add_text_story/send_story_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMediaStoryScreen extends StatefulWidget {
  final MessageType messageType;
  const AddMediaStoryScreen({
    Key? key,
    required this.messageType,
  }) : super(key: key);

  @override
  State<AddMediaStoryScreen> createState() => _AddMediaStoryScreenState();
}

class _AddMediaStoryScreenState extends State<AddMediaStoryScreen> {
  late StoriesCubit storiesCubit;
  @override
  void initState() {
    storiesCubit = StoriesCubit.get(context);
    storiesCubit.initAddTextStory();
    super.initState();
  }

  @override
  void dispose() {
    storiesCubit.disposeAddTextStory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoriesCubit, StoriesState>(
      listener: (context, state) {
        state.maybeWhen(
          sendStoryError: (errorMsg) => showSnackBar(
            context: context,
            message: errorMsg,
            color: AppColors.red,
          ),
          sendStory: () => Go.back(context: context),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = StoriesCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: state.maybeWhen(
              sendStoryLoading: () =>
                  const Center(child: CustomCircleIndicator()),
              getFilePercentage: () =>
                  const Center(child: CustomCircleIndicator()),
              orElse: () => Stack(
                children: [
                  if (widget.messageType == MessageType.image)
                    const ImageStory(),
                  if (widget.messageType == MessageType.video)
                    const VideoStory(),
                  const CloseButton(),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppHeight.h6, horizontal: AppWidth.w6),
                      child: Row(
                        children: [
                          CaptionTextField(controller: cubit.controller!),
                          SizedBox(
                            width: AppWidth.w5,
                          ),
                          SendStoryButton(
                            controller: cubit.controller!,
                            storyType: widget.messageType,
                          )
                        ],
                      ),
                    ),
                  ),
                  // if (state is AppSendLastStoryLoadingState)
                  //   Center(
                  //       child: CircularProgressIndicator(
                  //     value: cubit.storyFilePercentage == 0.0
                  //         ? 0.05
                  //         : cubit.storyFilePercentage,
                  //     color: AppColors.blue,
                  //     backgroundColor: AppColors.grey,
                  //   )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
