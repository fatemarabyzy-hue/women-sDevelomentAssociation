
import 'dart:convert';

class Course {
  final int? id;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final String dateRange;
  final String instructor;
  final String category;
  final bool isActive;
  final bool isFavorite;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.dateRange,
    required this.instructor,
    required this.category,
    this.isActive = true,
    this.isFavorite = false,
  });


  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      duration: json['duration'],
      dateRange: json['dateRange'],
      instructor: json['instructor'],
      category: json['category'],
      isActive: json['isActive'] ?? true,
      isFavorite: json['isFavorite'] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'duration': duration,
      'dateRange': dateRange,
      'instructor': instructor,
      'category': category,
      'isActive': isActive,
      'isFavorite': isFavorite,
    };
  }


  static List<Course> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Course.fromJson(json)).toList();
  }


  static String toJsonList(List<Course> courses) {
    final List<Map<String, dynamic>> jsonList = courses.map((c) => c.toJson()).toList();
    return json.encode(jsonList);
  }
}
