import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class StoryModel extends Equatable {
  final String id;
  final String? name;
  final String description;
  final String photoUrl;

  const StoryModel({
    required this.id,
    this.name,
    required this.description,
    required this.photoUrl,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  @override
  List<Object?> get props => [id, name, description, photoUrl];
}
