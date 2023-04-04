import 'package:flutter/material.dart';
import 'config.dart';

Widget _buildDefaultHeader<C, T>(
  BuildContext context,
  TimelineTrack<C, T> item,
  BoxConstraints constraints,
) =>
    item.header;

abstract class TrackHeadersBuilder<C, T> {
  const TrackHeadersBuilder();

  Widget build(
    BuildContext context,
    List<TimelineTrack<C, T>> tracks,
    VerticalTimelineConfiguration config,
  );
}

class DefaultMaterialHeader extends TrackHeadersBuilder<dynamic, dynamic> {
  final Color? color;
  final double elevation;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final TextAlign? textAlign;
  final Widget Function<C, T>(
    BuildContext context,
    TimelineTrack<C, T> item,
    BoxConstraints constraints,
  ) builder;

  const DefaultMaterialHeader({
    this.builder = _buildDefaultHeader,
    this.color = Colors.white,
    this.elevation = 1.0,
    this.textAlign,
    this.textStyle = const TextStyle(color: Colors.black),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  });

  @override
  Widget build(BuildContext context, List<TimelineTrack> tracks,
      VerticalTimelineConfiguration config) {
    return Material(
      color: color,
      elevation: elevation,
      child: Row(
        children: [
          SizedBox(
            width: config.padding.left,
          ),
          ...tracks.map((e) => Container(
                padding: padding,
                width: config.trackWidth,
                child: DefaultTextStyle(
                  style: textStyle,
                  textAlign: textAlign,
                  child: LayoutBuilder(
                    builder: (context, constraints) =>
                        builder(context, e, constraints),
                  ),
                ),
              )),
          SizedBox(
            width: config.padding.left,
          )
        ],
      ),
    );
  }
}
