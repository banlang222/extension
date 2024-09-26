import 'dart:math' as math;
import 'map.dart';
extension ListExtension<E> on List<E>? {
  bool get isNullOrEmpty {
    return this == null ? true : this!.isEmpty;
  }

  List<E>? copy() {
    if(this == null) return null;
    if(this!.isEmpty) return this;
    var _list = <E>[];
    this!.forEach((element) {
      if(element is Map){
        _list.add(element.copy() as E);
      }
      else if(element is List){
        _list.add(element.copy() as E);
      }
      else {
        _list.add(element);
      }
    });
    return _list;
  }

  List<E>? getRandomList(int n) {
    if(isNullOrEmpty) return this;
    var _list = <E>[];
    var _n = this!.length > n ? n : this!.length;
    var random = math.Random();
    while(_list.length < n && _list.length < this!.length) {
      var element = this!.elementAt(random.nextInt(_n));
      if(!_list.contains(element)){
        _list.add(element);
      }
    }
    return _list;
  }
}
extension SetExtension on Set? {
  bool get isNullOrEmpty {
    return this == null ? true : this!.isEmpty;
  }
}
extension IterableExtension on Iterable? {
  bool get isNullOrEmpty {
    return this == null ? true : this!.isEmpty;
  }
}

