import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/bloc/story/story_bloc.dart';
import 'package:story_app/shared/theme.dart';
import 'package:story_app/view/widgets/story_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SafeArea(
        child: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            if (state is StorySuccess) {
              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 24.h,
                ),
                children: state.stories
                    .map(
                      (story) => StoryWidget(
                          story: story,
                          onTap: () {
                            context.pushNamed(
                              'detail',
                              params: {'storyId': story.id},
                            );
                          }),
                    )
                    .toList(),
              );
            }

            if (state is StoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is StoryFailed) {
              return Center(
                child: Text(
                  state.e,
                  style: primaryTextStyle.copyWith(
                    fontSize: 18.sp,
                    fontWeight: bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
