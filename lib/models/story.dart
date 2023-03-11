import 'package:equatable/equatable.dart';

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

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photoUrl: json['photoUrl'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        photoUrl,
      ];
}
