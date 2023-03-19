import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class StoryModel extends Equatable {
  final String id;
  final String? name;
  final String description;
  final String photoUrl;
  final double? latitude;
  final double? longitude;

  const StoryModel({
    required this.id,
    this.name,
    required this.description,
    required this.photoUrl,
    this.latitude,
    this.longitude,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  @override
  List<Object?> get props => [id, name, description, photoUrl];
}
