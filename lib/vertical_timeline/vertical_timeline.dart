import 'package:flutter/material.dart';
import 'package:netflex_timeline/extensions/track_list.dart';
import 'package:netflex_timeline/vertical_timeline/track_background.dart';
import 'package:netflex_timeline/vertical_timeline/track_header.dart';
import 'config.dart';

part 'duration.dart';

typedef Widget TimelineItemBuilder<C, T>(BuildContext context,
    TimelineItem<T> item, C? config, BoxConstraints constraints);

typedef Widget TimelineTimeMarkerBuilder(BuildContext context, DateTime time);

class VerticalTimeline<C, T> extends StatefulWidget {
  final VerticalTimelineConfiguration config;
  final List<TimelineTrack<C, T>> tracks;
  final TrackHeadersBuilder trackHeadersBuilder;
  final TrackBackgroundBuilder trackBackgroundBuilder;
  final TimelineItemBuilder<C, T> itemBuilder;
  final TimelineTimeMarkerBuilder timeBuilder;

  const VerticalTimeline({
    Key? key,
    this.config = const VerticalTimelineConfiguration(),
    this.trackHeadersBuilder = const DefaultMaterialHeader(),
    this.trackBackgroundBuilder = const AlternatingBackgroundColor(),
    required this.timeBuilder,
    required this.tracks,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  State<VerticalTimeline<C, T>> createState() => _VerticalTimelineState<C, T>();
}

class _VerticalTimelineState<C, T> extends State<VerticalTimeline<C, T>> {
  var controller = TransformationController();
  var offset = Offset.zero;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        offset = controller.toScene(Offset.zero);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var timeSpan = widget.config.durationResolver.resolve(widget.tracks);
    var containerWidth = widget.config.canvasWidth(widget.tracks.length);

    return InteractiveViewer(
      transformationController: controller,
      constrained: false,
      panAxis: PanAxis.free,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: containerWidth,
              height:
                  timeSpan.duration.inSeconds * widget.config.pixelsPerSecond,
              child: Stack(
                children: [
                  /// Track backgrounds
                  ..._tracks(timeSpan),
                  ..._items(timeSpan),
                  ..._timelineEntries(timeSpan),
                  _headers(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headers() => Positioned(
        top: widget.config.floatingHeader ? offset.dy : 0,
        child: widget.trackHeadersBuilder
            .build(context, widget.tracks, widget.config),
      );

  Iterable<Widget> _timelineEntries(TimelineDuration duration) =>
      duration.each(const Duration(hours: 1)).map(
            (e) => Positioned(
              top: widget.config.pixelsPerSecond *
                  e.difference(duration.from).inSeconds,
              left: widget.config.floatingTime ? offset.dx : 0,
              child: widget.timeBuilder(context, e),
            ),
          );

  List<Widget> _tracks(TimelineDuration duration) => [
        if (widget.config.padding.left > 0) _createLeftPadding(duration),
        ...widget.tracks
            .asMap()
            .entries
            .map((e) => widget.config.positionedTrack(
                  e.key,
                  (context, constraints) => widget.trackBackgroundBuilder.build(
                    context,
                    e.value,
                    e.key,
                    widget.config,
                    duration,
                    constraints,
                  ),
                )),
        if (widget.config.padding.right > 0) _createRightPadding(duration),
      ];

  Iterable<Widget> _items(TimelineDuration duration) =>
      widget.tracks.allTracked.map((e) => widget.config.positionedItem(
            e.value,
            e.index,
            duration,
            (context, constraints) => widget.itemBuilder(
              context,
              e.value,
              e.key.trackConfig,
              constraints,
            ),
          ));

  Positioned _createLeftPadding(TimelineDuration _duration) {
    return Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        child: SizedBox(
          width: widget.config.padding.left,
          child: LayoutBuilder(
            builder: (context, constraints) =>
                widget.trackBackgroundBuilder.build(
              context,
              PaddingTrack(),
              -1,
              widget.config,
              _duration,
              constraints,
            ),
          ),
        ));
  }

  Positioned _createRightPadding(TimelineDuration _duration) {
    return Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        child: SizedBox(
          width: widget.config.padding.right,
          child: LayoutBuilder(
            builder: (context, constraints) =>
                widget.trackBackgroundBuilder.build(
              context,
              PaddingTrack(),
              widget.tracks.length,
              widget.config,
              _duration,
              constraints,
            ),
          ),
        ));
  }
}
