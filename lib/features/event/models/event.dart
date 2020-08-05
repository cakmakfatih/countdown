import '../../../core/util/constants.dart';
import 'category.dart';
import 'repeat.dart';
import 'typed_image.dart';

class Event {
  final int id;
  final String title;
  TypedImage image;
  final Category category;
  final String dateString;
  final Repeat repeat;
  final bool notify;

  Event({
    this.id,
    this.title,
    this.image,
    this.category,
    this.dateString,
    this.repeat: const Repeat(RepeatValue.never),
    this.notify: true,
  });

  factory Event.fromJson(Map<String, dynamic> jsonMap) {
    return Event(
      id: jsonMap["id"],
      title: jsonMap["title"],
      image: TypedImage.fromJson(jsonMap["image"] as Map<String, dynamic>),
      category: Category.fromString(jsonMap["category"]),
      dateString: jsonMap["dateString"],
      repeat: Repeat.fromInt(jsonMap["repeat"]),
      notify: jsonMap["notify"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "image": image.toJson(),
      "category": category.name,
      "dateString": dateString,
      "repeat": repeat.value,
      "notify": notify,
    };
  }
}
