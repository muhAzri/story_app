import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/bloc/story/story_bloc.dart';
import 'package:story_app/shared/method.dart';
import 'package:story_app/view/widgets/story_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _refresh() async {
    context.read<StoryBloc>().add(FetchStoriesEvent());
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    context.read<StoryBloc>().add(FetchStoriesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<StoryBloc>().add(FetchStoriesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SafeArea(
        child: BlocConsumer<StoryBloc, StoryState>(
          listener: (context, state) {
            if (state is StoryFailed) {
              showCustomSnackbar(context, state.e);
            }
          },
          builder: (context, state) {
            if (state is StorySuccess) {
              final stories = state.stories;
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 24.h,
                ),
                controller: _scrollController,
                itemCount: stories.length + (state.pageItems != null ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == stories.length && state.pageItems != null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return StoryWidget(
                    story: stories[index],
                    onTap: () {
                      context.pushNamed(
                        'detail',
                        params: {'storyId': stories[index].id},
                      );
                    },
                  );
                },
              );
            }

            if (state is StoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
