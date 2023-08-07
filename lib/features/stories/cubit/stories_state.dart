part of 'stories_cubit.dart';

@freezed
class StoriesState with _$StoriesState {
  const factory StoriesState.initial() = _Initial;
  const factory StoriesState.getPhones() = _GetPhones;
  const factory StoriesState.initAddTextStory() = _InitAddTextStory;
  const factory StoriesState.disposeAddTextStory() = _DisposeAddTextStory;
  const factory StoriesState.pickStoryMediaLoading() = _PickStoryMediaLoading;
  const factory StoriesState.pickStoryImage() = _PickStoryImage;
  const factory StoriesState.pickStoryImageError() = _PickStoryImageError;
  const factory StoriesState.pickStoryVideo() = _PickStoryVideo;
  const factory StoriesState.pickStoryVideoError() = _PickStoryVideoError;
  const factory StoriesState.setVideoDuration() = _SetVideoDuration;
  const factory StoriesState.sendStoryLoading() = _SendStoryLoading;
  const factory StoriesState.sendStory() = _SendStory;
  const factory StoriesState.sendStoryError(String errorMsg) = _SendStoryError;
  const factory StoriesState.getFilePercentage() = _GetFilePercentage;
  const factory StoriesState.setImageDimensions() = _SetImageDimensions;
  const factory StoriesState.getMyStoriesLoading() = _GetMyStoriesLoading;
  const factory StoriesState.getMyStories() = _GetMyStories;
  const factory StoriesState.getMyStoriesError(String errorMsg) =
      _GetMyStoriesError;
  const factory StoriesState.initStoryView() = _InitStoryView;
  const factory StoriesState.disposeStoryView() = _DisposeStoryView;
  const factory StoriesState.changeStoryIndexLoading() =
      _ChangeStoryIndexLoading;
  const factory StoriesState.changeStoryIndex() = _ChangeStoryIndex;
  const factory StoriesState.resetStoryIndex() = _ResetStoryIndex;
  const factory StoriesState.deleteStoryLoading() = _DeleteStoryLoading;
  const factory StoriesState.deleteStory() = _DeleteStory;
  const factory StoriesState.deleteStoryError(String errorMsg) =
      _DeleteStoryError;
}
