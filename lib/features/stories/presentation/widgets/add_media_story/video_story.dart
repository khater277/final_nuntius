import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/features/stories/cubit/stories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoStory extends StatefulWidget {
  const VideoStory({Key? key}) : super(key: key);

  @override
  _VideoStoryState createState() => _VideoStoryState();
}

class _VideoStoryState extends State<VideoStory> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.file(StoriesCubit.get(context).storyFile!)
          ..initialize().then((_) {
            StoriesCubit.get(context)
                .setVideoDuration(_controller!.value.duration.toString());
            // print("==============>${_controller!.value.duration}");
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
    _controller!.play();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller!),
                  _ControlsOverlay(controller: _controller!),
                  VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                        playedColor: AppColors.blue,
                        backgroundColor: AppColors.lightBlack.withOpacity(0.5)),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
