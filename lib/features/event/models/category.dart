import 'package:flutter/material.dart';

class Category {
  final String name;

  IconData get icon {
    if (name == "Love")
      return Icons.favorite;
    else if (name == "Birthday")
      return Icons.cake;
    else if (name == "Education")
      return Icons.school;
    else if (name == "Business")
      return Icons.business;
    else if (name == "Holiday")
      return Icons.beach_access;
    else if (name == "Travel")
      return Icons.flight;
    else if (name == "Health")
      return Icons.local_hospital;
    else if (name == "Sports") return Icons.fitness_center;

    return Icons.event;
  }

  const Category(this.name);

  factory Category.fromString(String name) {
    return Category(name);
  }
}
