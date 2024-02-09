import 'dart:math';

import 'package:flutter/material.dart';

final class HomeController {
  final ValueNotifier<int> initialNumber = ValueNotifier(0);
  final ValueNotifier<int?> lastDrawedNumber = ValueNotifier(null);
  final ValueNotifier<int> lastNumber = ValueNotifier(3);
  final ValueNotifier<bool> cantRepeatNumber = ValueNotifier(false);
  final ValueNotifierList<int> history = ValueNotifierList([]);
  final ValueNotifier<bool> allListDrawed = ValueNotifier(false);

  draw() {
    if (cantRepeatNumber.value) {
      int drawed = 0;
      if (!allListDrawed.value) {
        do {
          drawed = Random().nextInt(lastNumber.value + 1) + initialNumber.value;
        } while (history.value.contains(drawed));
        lastDrawedNumber.value = drawed;

        history.add(drawed);
      }
      allListDrawed.value =
          history.value.length == lastNumber.value - initialNumber.value + 1;
    } else {
      int drawed = Random().nextInt(lastNumber.value) + initialNumber.value;
      lastDrawedNumber.value = drawed;

      history.add(drawed);
    }
  }

  clean() {
    history.value = [];
    allListDrawed.value =
        history.value.length == lastNumber.value - initialNumber.value + 1;
  }
}

class ValueNotifierList<T> extends ValueNotifier<List<T>> {
  ValueNotifierList(List<T> value) : super(value);

  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }
}
