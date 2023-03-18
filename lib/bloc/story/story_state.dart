part of 'story_bloc.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object?> get props => [];
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
  final int? pageItems;
  final int sizeItems;

  const StorySuccess(this.stories, this.pageItems, this.sizeItems);

  @override
  List<Object?> get props => [stories, pageItems, sizeItems];

  int get itemCount {
    return stories.length + (pageItems != null ? 1 : 0);
  }
}

class DetailStorySuccess extends StoryState {
  final StoryModel story;

  const DetailStorySuccess(this.story);

  @override
  List<Object> get props => [story];
}
