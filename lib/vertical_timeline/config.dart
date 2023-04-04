import 'package:flutter/cupertino.dart';
import 'package:netflex_timeline/netflex_timeline.dart';

class VerticalTimelineConfiguration {
  final double trackWidth;
  final double pixelsPerHour;
  final double pixelsPerSecond;
  final EdgeInsets padding;
  final bool floatingHeader;
  final bool floatingTime;
  final TimelineDurationResolver durationResolver;

  const VerticalTimelineConfiguration({
    this.trackWidth = 200,
    this.pixelsPerHour = 300,
    this.floatingHeader = true,
    this.floatingTime = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.durationResolver = const DynamicTimelineDuration(),
  }) : pixelsPerSecond = pixelsPerHour / 3600;

  double canvasWidth(int trackCount) {
    return padding.horizontal + (trackWidth * trackCount);
  }

  double trackOffset(int track) {
    return padding.left + (trackWidth * track);
  }

  Widget positionedTrack(
          int index,
          Widget Function(BuildContext context, BoxConstraints constraints)
              builder) =>
      Positioned(
        top: 0,
        left: trackOffset(index),
        bottom: 0,
        child: SizedBox(
          width: trackWidth,
          child: LayoutBuilder(
            builder: builder,
          ),
        ),
      );

  Widget positionedItem(
          TimelineItem item,
          int index,
          TimelineDuration bounds,
          Widget Function(BuildContext context, BoxConstraints constraints)
              builder) =>
      Positioned(
          top: item.from.difference(bounds.from).inSeconds.abs() * pixelsPerSecond,
          left: trackOffset(index),
          child: SizedBox(
            width: trackWidth,
            height: (item.duration.inSeconds * pixelsPerSecond).abs(),
            child: LayoutBuilder(
              builder: builder,
            ),
          ));
}

class TimelineTrack<C, T> {
  final Color? backgroundColor;
  final C? trackConfig;
  final Widget header;

  final List<TimelineItem<T>> items;

  TimelineTrack({
    this.backgroundColor,
    this.trackConfig,
    required this.header,
    required this.items,
  });
}

class PaddingTrack<C, T> extends TimelineTrack<C, T> {
  PaddingTrack()
      : super(
          header: const SizedBox(
            height: 0,
            width: 0,
          ),
          items: [],
        );
}

class TimelineItem<T> {
  final DateTime from;
  final DateTime to;
  final T item;

  TimelineItem({required this.from, required this.to, required this.item});

  Duration get duration => from.difference(to);
}
