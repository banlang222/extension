import 'list.dart';

extension MapExtension<K, V> on Map<K, V>? {
  bool get isNullOrEmpty {
    return this == null ? true : this!.isEmpty;
  }

  Map<K, V>? copy() {
    if (this == null) return null;
    if (this!.isEmpty) return this!;
    var _map = <K, V>{};
    this!.forEach((key, value) {
      if (value is Map) {
        _map[key] = value.copy() as V;
      } else if (value is List) {
        _map[key] = value.copy() as V;
      } else {
        _map[key] = value;
      }
    });
    return _map;
  }

  bool equalTo(Map<K, V>? other) {
    if (runtimeType != other.runtimeType) return false;
    if (this == null || other == null) return false;
    if (this!.length != other.length) return false;
    var equal = true;
    for (var entry in this!.entries) {
      //对比键
      if (!other.containsKey(entry.key)) {
        equal = false;
        break;
      }
      //对比值
      else {
        if (entry.value.runtimeType != other[entry.key].runtimeType) {
          equal = false;
          break;
        } else if (entry.value is Map) {
          if (!(entry.value as Map).equalTo(other[entry.key] as Map)) {
            equal = false;
            break;
          }
        } else if (entry.value is List) {
          if (!(entry.value as List).equalTo(other[entry.key] as List)) {
            equal = false;
            break;
          }
        } else {
          if (entry.value != other[entry.key]) {
            equal = false;
            break;
          }
        }
      }
    }

    return equal;
  }
}
