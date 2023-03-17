part of 'story_bloc.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object> get props => [];
}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryFailed extends StoryState {
  final String e;

  const StoryFailed(this.e);

  @override
  List<Object> get props => [e];
}

class StorySuccess extends StoryState {
  final List<StoryModel> stories;

  const StorySuccess(this.stories);

  @override
  List<Object> get props => [stories];
}

class DetailStorySuccess extends StoryState {
  final StoryModel story;

  const DetailStorySuccess(this.story);

  @override
  List<Object> get props => [story];
}
