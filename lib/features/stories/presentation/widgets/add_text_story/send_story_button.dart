import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_enums.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendStoryButton extends StatelessWidget {
  final TextEditingController controller;
  final MessageType storyType;
  const SendStoryButton(
      {Key? key, required this.controller, required this.storyType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
      child: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          return IconButton(
            onPressed: state != const StoriesState.sendStoryLoading() ||
                    state != const StoriesState.getFilePercentage()
                ? () {
                    storyType == MessageType.text
                        ? StoriesCubit.get(context).sendStory()
                        : StoriesCubit.get(context)
                            .sendMediaStory(mediaType: storyType);
                  }
                : null,
            icon: const Icon(
              IconBroken.Send,
              color: AppColors.white,
            ),
          );
        },
      ),
    );
  }
}
