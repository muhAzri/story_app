part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object> get props => [];
}

class FetchStoriesEvent extends StoryEvent {}

class AddStoryEvent extends StoryEvent {
  final AddStoryFormModel formModel;

  const AddStoryEvent(this.formModel);

  @override
  List<Object> get props => [formModel];
}
