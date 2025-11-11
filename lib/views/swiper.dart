//import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerbloc/blocs/player_bloc.dart';
import 'package:playerbloc/blocs/player_load_events.dart';
import 'package:playerbloc/blocs/player_load_states.dart';
import 'package:playerbloc/blocs/player_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/audio_item.dart';

class Swiper extends StatefulWidget {
  // de staless a  statefulWidget
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
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  bool _isProgrammaticScroll = false; //  bandera para controlar el scroll de la animacion shittier

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayState>(
      bloc: widget.bloc,
      listenWhen: (prev, curr) =>
      curr is PlayingState &&
          (prev is! PlayingState || curr.currentIndex != (prev).currentIndex),
      listener: (context, state) async {
        if (state is PlayingState) {
          _isProgrammaticScroll = true;
            await widget.pageController.animateToPage(
              state.currentIndex,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );

          //esto para deesactivar bandera DESPUES de mover
          await Future.delayed(Duration(milliseconds: 100));
          _isProgrammaticScroll = false;
        }
      },
      child: BlocBuilder<PlayerBloc, PlayState>(
        builder: (context, state) {
          return Column(
            children: <Widget>[
              SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1 / 3,
                child: PageView.builder(
                  controller: widget.pageController,
                  itemCount: widget.audioList.length,
                  onPageChanged: (indice) {
                    if (_isProgrammaticScroll) {
                      debugPrint(
                        '⚠ Ignorando onPageChanged - Scroll programático',
                      );
                      return;
                    }

                    final actual = widget.bloc.state;
                    if (actual is PlayingState &&
                        indice != actual.currentIndex) {
                      debugPrint('👆 Usuario cambió de página a: $indice');
                      widget.bloc.add(PlayerLoadEvent(indice));
                    }
                  },
                  itemBuilder: (context, index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        widget.audioList[index].imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SmoothPageIndicator(
                controller: widget.pageController,
                count: widget.audioList.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 8.0,
                  dotWidth: 16.0,
                  dotHeight: 16.0,
                  paintStyle: PaintingStyle.stroke,
                  strokeWidth: 2.0,
                  dotColor: widget.color,
                  activeDotColor: Color(0xff800020),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}