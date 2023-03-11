import 'dart:io';

import 'package:equatable/equatable.dart';


class AddStoryFormModel extends Equatable {
  final File image;
  final String description;

  const AddStoryFormModel(this.image, this.description);

  Map<String, dynamic> toJson() {
    return {
      'photo': image,
      'description': description,
    };
  }

  AddStoryFormModel copywith({
    required File? image,
  }) =>
      AddStoryFormModel(
        image!,
        description,
      );

  @override
  List<Object?> get props => [image, description];
}
