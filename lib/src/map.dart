import 'list.dart';
extension MapExtension<K, V> on Map<K, V>? {
  bool get isNullOrEmpty {
    return this == null ? true : this!.isEmpty;
  }

  Map<K, V>? copy() {
    if(this == null) return null;
    if(this!.isEmpty) return this!;
    var _map = <K, V>{};
    this!.forEach((key, value) {
      if(value is Map){
        _map[key] = value.copy() as V;
      } else if(value is List){
        _map[key] = value.copy() as V;
      } else {
        _map[key] = value;
      }
    });
    return _map;
  }

  bool equalTo(Map<K, V>? other) {
    if(runtimeType != other.runtimeType) return false;
    if(this == null || other == null) return false;
    if(this!.length != other.length) return false;
    var equal = true;
    for(var key in this!.keys){
      if(!other.containsKey(key)){
        equal = false;
        break;
      } else if(this![key] != other[key]){
        equal = false;
        break;
      }
    }
    return equal;
  }
}


