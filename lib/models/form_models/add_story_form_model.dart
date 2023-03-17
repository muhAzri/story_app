import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_story_form_model.g.dart';

@JsonSerializable()
class AddStoryFormModel extends Equatable {
  final XFile image;
  final String description;

  const AddStoryFormModel(this.image, this.description);

  Map<String, dynamic> toJson() => _$AddStoryFormModelToJson(this);

  @override
  List<Object?> get props => [image, description];
}
