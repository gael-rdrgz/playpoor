//import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerbloc/blocs/player_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/blocs/player_load_states.dart';
import 'package:playerbloc/blocs/player_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/audio_item.dart';

class Swiper extends StatelessWidget {
  final PageController pageController;
  final List<AudioItem> audioList;
  final Color color;
  final PlayerBloc bloc;

  const Swiper({
    super.key,
    required this.pageController,
    required this.audioList,
    required this.color,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayState>(
      bloc: bloc,
      listenWhen: (prev, curr) =>
          curr is PlayingState &&
          (prev is! PlayingState || curr.currentIndex != (prev).currentIndex),
      listener: (context, state) {
        if (state is PlayingState) {
          if (pageController.offset == 0) {
            pageController.jumpToPage(state.currentIndex);
          } else {
            pageController.animateToPage(
              state.currentIndex,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      child: BlocBuilder<PlayerBloc, PlayState>(
        builder: (context, state) {
          return Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .3,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: audioList.length,
                  onPageChanged: (indice) {
                    final actual = bloc.state;
                    if (actual is PlayingState &&
                        indice != actual.currentIndex) {
                      bloc.add(PlayerLoadEvent(indice));
                    }
                  },
                  itemBuilder: (contex, index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        audioList[index].imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              //Divider(),
              //Spacer()
              SizedBox(height: 15),
              SmoothPageIndicator(
                controller: pageController,
                count: audioList.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 4.0,
                  dotWidth: 24.0,
                  dotHeight: 16.0,
                  paintStyle: PaintingStyle.stroke,
                  strokeWidth: 1.5,
                  dotColor: Colors.grey,
                  activeDotColor: color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
