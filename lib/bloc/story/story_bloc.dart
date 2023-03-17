import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:story_app/models/form_models/add_story_form_model.dart';
import 'package:story_app/models/story.dart';
import 'package:story_app/services/story_service.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc() : super(StoryInitial()) {
    on<FetchStoriesEvent>((event, emit) async {
      try {
        emit(StoryLoading());

        final stories = await StoryService().fetchStories();

        emit(StorySuccess(stories));
      } catch (e) {
        emit(StoryFailed(e.toString()));
      }
    });

    on<AddStoryEvent>((event, emit) async {
      try {
        emit(StoryLoading());

        final stories = await StoryService().addStory(event.formModel);

        emit(StorySuccess(stories));
      } catch (e) {
        emit(
          StoryFailed(
            e.toString(),
          ),
        );
      }
    });

    on<GetStoryByIdEvent>((event, emit) async {
      try {
        emit(StoryLoading());

        final story = await StoryService().getStoryById(event.storyId);

        emit(DetailStorySuccess(story));
      } catch (e) {
        emit(StoryFailed(e.toString()));
      }
    });
  }
}
