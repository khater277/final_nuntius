import 'package:final_nuntius/features/stories/data/models/viewer_model/viewer_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class StoryModel with _$StoryModel {
  factory StoryModel({
    String? id,
    String? date,
    bool? isImage,
    bool? isRead,
    bool? isVideo,
    String? videoDuration,
    String? media,
    String? phone,
    String? text,
    List<ViewerModel>? viewers,
    List<String>? canView,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}
