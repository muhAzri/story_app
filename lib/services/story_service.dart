import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/models/form_models/add_story_form_model.dart';
import 'package:story_app/services/auth_service.dart';

import '../models/story.dart';

class StoryService {
  static const baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<List<StoryModel>> fetchStories({int? page}) async {
    try {
      const size = 10;

      final token = await AuthService().getToken();

      final res = await http.get(
        Uri.parse(
          '$baseUrl/stories?size=$size&page=$page',
        ),
        headers: {
          "Authorization": token,
        },
      );
      if (res.statusCode == 200) {
        return List<StoryModel>.from(
          jsonDecode(res.body)['listStory'].map(
            (story) => StoryModel.fromJson(story),
          ),
        ).toList();
      }

      throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StoryModel>> addStory(AddStoryFormModel formModel) async {
    try {
      final token = await AuthService().getToken();

      final compressedImage = await compressImageFile(File(formModel.image.path));

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/stories'),
      );
      request.headers['Authorization'] = token;

      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          compressedImage,
          filename: 'compressed_image.jpg',
        ),
      );

      request.fields['description'] = formModel.description;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final stories = await fetchStories();
        return stories;
      }

      throw jsonDecode(response.body)['message'];
    } catch (e) {
      rethrow;
    }
  }

  Future<StoryModel> getStoryById(String storyId) async {
    try {
      final token = await AuthService().getToken();

      final res = await http.get(
        Uri.parse('$baseUrl/stories/$storyId'),
        headers: {
          'Authorization': token,
        },
      );

      if (res.statusCode == 200) {
        StoryModel storyDetail =
            StoryModel.fromJson(jsonDecode(res.body)['story']);

        return storyDetail;
      }

      throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> compressImageFile(File imageFile) async {
    final compressedImage = await FlutterImageCompress.compressWithList(
      imageFile.readAsBytesSync(),
      minHeight: 1920,
      minWidth: 1080,
      quality: 80,
      format: CompressFormat.jpeg,
    );

    return compressedImage;
  }
}
