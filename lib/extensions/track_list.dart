import 'package:netflex_timeline/netflex_timeline.dart';

class IndexedMapEntry<C, T> {
  final TimelineTrack<C, T> key;
  final TimelineItem<T> value;
  final int index;

  IndexedMapEntry(this.key, this.value, this.index);
}

extension IterateTrack<C, T> on List<TimelineTrack<C, T>> {
  Iterable<TimelineItem<T>> get allItems sync* {
    for (var track in this) {
      for (var item in track.items) {
        yield item;
      }
    }
  }
}

extension Tracked<C, T> on List<TimelineTrack<C, T>> {
  Iterable<IndexedMapEntry<C, T>> get allTracked sync* {
    var index = 0;
    for (var track in this) {
      for (var item in track.items) {
        yield IndexedMapEntry<C, T>(track, item, index);
      }
      index++;
    }
  }
}
