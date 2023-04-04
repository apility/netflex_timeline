
import 'package:flutter/widgets.dart';
import 'package:netflex_timeline/netflex_timeline.dart';

abstract class TimelineTimeMarkerBuilder {
  Widget build(BuildContext context, TimelineDuration duration, VerticalTimelineConfiguration configuration);
}
