import 'package:countdown/features/event/models/category.dart';
import 'package:countdown/features/event/models/repeat.dart';
import 'package:countdown/features/event/models/typed_image.dart';

abstract class Constants {
  static const List<Category> categories = [
    Category("Love"),
    Category("Birthday"),
    Category("Education"),
    Category("Business"),
    Category("Holiday"),
    Category("Travel"),
    Category("Health"),
    Category("Sports"),
    Category("Other"),
  ];

  static const List<Repeat> repeats = [
    Repeat(RepeatValue.never),
    Repeat(RepeatValue.week),
  ];

  static const List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
}

abstract class ImageSourceType {
  static const int asset = 0;
  static const int network = 1;
  static const int gallery = 2;
}

abstract class RepeatValue {
  static const int never = 0;
  static const int week = 1;
  static const int month = 2;
  static const int year = 3;
}

List<TypedImage> allImages = [
  TypedImage(
    path: "images/01.jpg",
    type: ImageSourceType.asset,
  ),
  TypedImage(
    path: "images/02.jpg",
    type: ImageSourceType.asset,
  ),
  TypedImage(
    path: "images/03.jpg",
    type: ImageSourceType.asset,
  ),
];
