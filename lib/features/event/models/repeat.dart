import '../../../core/util/constants.dart';

class Repeat {
  final int value;

  String get title {
    if (value == RepeatValue.never) {
      return "Never";
    } else if (value == RepeatValue.week) {
      return "Weekly";
    }

    return null;
  }

  factory Repeat.fromInt(int value) {
    return Repeat(value);
  }

  const Repeat(this.value);
}
