part of 'vertical_timeline.dart';

class TimelineDuration {
  final DateTime from;
  final DateTime to;

  TimelineDuration(this.from, this.to);

  TimelineDuration copyWith(TimelineItem ti) {
    return TimelineDuration(
      from.isAfter(ti.from) ? ti.from : from,
      to.isBefore(ti.to) ? ti.to : to,
    );
  }

  Duration get duration => to.difference(from);

  Iterable<DateTime> each(Duration interval) sync* {
    var now = from.subtract(Duration(minutes: from.minute));
    while (now.isBefore(to)) {
      yield now;
      now = now.add(interval);
    }
  }

  Duration get beforeFirstHour => from.difference(DateTime(
        from.year,
        from.month,
        from.day,
        from.hour,
      )).abs();
}

DateTime _atStartOfHour(DateTime date) =>
    DateTime(date.year, date.month, date.day, date.hour);

abstract class TimelineDurationResolver {
  const TimelineDurationResolver();

  TimelineDuration resolve(List<TimelineTrack> tracks);
}

class AbsoluteTimelineDuration extends TimelineDurationResolver {
  final DateTime from;
  final DateTime to;

  AbsoluteTimelineDuration(this.from, this.to);

  @override
  TimelineDuration resolve(List<TimelineTrack> tracks) {
    return TimelineDuration(from, to);
  }
}

class DynamicTimelineDuration extends TimelineDurationResolver {
  final Duration padBefore;
  final Duration padAfter;

  const DynamicTimelineDuration({
    this.padBefore = const Duration(hours: 0),
    this.padAfter = const Duration(hours: 1),
  });

  @override
  TimelineDuration resolve(List<TimelineTrack> tracks) {
    var dateTime = tracks.allItems.fold(
      TimelineDuration(
          tracks.first.items.first.from, tracks.first.items.first.to),
      (previousValue, element) => previousValue.copyWith(element),
    );

    return TimelineDuration(
      _atStartOfHour(dateTime.from).subtract(padBefore),
      _atStartOfHour(dateTime.to).add(padAfter),
    );
  }
}
