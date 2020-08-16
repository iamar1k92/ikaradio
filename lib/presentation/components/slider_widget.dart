import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:base/presentation/blocs/slider/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SliderWidget extends StatefulWidget {
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final SliderBloc _sliderBloc = SliderBloc();

  @override
  void initState() {
    super.initState();
    _sliderBloc.add(LoadSliders());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (BuildContext context, LanguageState state) {
        _sliderBloc.add(LoadSliders());
      },
      child: BlocProvider<SliderBloc>(
        create: (BuildContext context) => _sliderBloc,
        child: BlocBuilder<SliderBloc, SliderState>(
          bloc: _sliderBloc,
          builder: (BuildContext context, SliderState state) {
            if (state is SlidersLoaded) {
              if (state.sliders.length > 0) {
                return Container(
                  width: double.infinity,
                  child: CarouselSlider.builder(
                    itemCount: state.sliders.length,
                    itemBuilder: (BuildContext context, int index) {
                      var _slider = state.sliders[index];
                      return Container(
                        width: double.infinity,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: CachedNetworkImage(
                                imageUrl: _slider.cover,
                                placeholder: (context, url) => Center(child: SizedBox(width: 50.0, height: 50.0, child: CircularProgressIndicator())),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color.fromARGB(100, 0, 0, 0), Color.fromARGB(100, 0, 0, 0)],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  _slider.title,
                                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                    ),
                  ),
                );
              }
            }
            return SizedBox(height: 0);
          },
        ),
      ),
    );
  }
}
