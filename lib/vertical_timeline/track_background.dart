import 'package:flutter/widgets.dart';
import 'package:netflex_timeline/netflex_timeline.dart';

abstract class TrackBackgroundBuilder<C, T> {
  const TrackBackgroundBuilder();

  Widget build(
    BuildContext context,
    TimelineTrack track,
    int index,
    VerticalTimelineConfiguration config,
    TimelineDuration duration,
    BoxConstraints constraints,
  );
}

class AlternatingBackgroundColor
    extends TrackBackgroundBuilder<dynamic, dynamic> {
  final List<Color> colors;

  const AlternatingBackgroundColor(
      [this.colors = const [
        Color(0xFFFAFAFA),
        Color(0x00000000),
      ]]);

  @override
  Widget build(
    BuildContext context,
    TimelineTrack track,
    int index,
    VerticalTimelineConfiguration config,
    TimelineDuration duration,
    BoxConstraints constraints,
  ) {




    return Container(
      color: colors[index % colors.length],
      child: Stack(
        children: [
          ...duration.each(Duration(hours: 1)).map((e) => Positioned(
                top: config.pixelsPerSecond *
                    e.difference(duration.from).inSeconds,
                child: Container(
                  height: config.pixelsPerHour / 2,
                  width: config.trackWidth,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Color(0x34000000),
                      width: .5,
                    ),
                  )),
                ),
              ))
        ],
      ),
    );
  }
}
