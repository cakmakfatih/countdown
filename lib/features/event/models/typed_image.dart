import 'package:meta/meta.dart';

class TypedImage {
  final int type;
  final String path;

  TypedImage({@required this.type, @required this.path});

  factory TypedImage.fromJson(Map<String, dynamic> jsonMap) {
    return TypedImage(
      type: jsonMap["type"],
      path: jsonMap["path"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "path": path,
    };
  }
}
