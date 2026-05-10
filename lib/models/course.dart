
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

  // ✅ من Map (SQLite) إلى Object
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      duration: map['duration'] as String,
      dateRange: map['dateRange'] as String,
      instructor: map['instructor'] as String,
      category: map['category'] as String,
      isActive: map['isActive'] == 1,
      isFavorite: map['isFavorite'] == 1,
    );
  }

  // ✅ من Object إلى Map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'duration': duration,
      'dateRange': dateRange,
      'instructor': instructor,
      'category': category,
      'isActive': isActive ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // ✅ من JSON إلى Object
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

  // ✅ من Object إلى JSON
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

  Course copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    String? duration,
    String? dateRange,
    String? instructor,
    String? category,
    bool? isActive,
    bool? isFavorite,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      dateRange: dateRange ?? this.dateRange,
      instructor: instructor ?? this.instructor,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static List<Course> getSampleCourses() {
    return [
      Course(
        title: 'دورة الخياطة والتفصيل',
        description: 'تعلم أصول الخياطة والتفصيل لأحسن الأثواب',
        imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400',
        duration: '12 ساعة',
        dateRange: '17 يونيو - 8 يوليو',
        instructor: 'أ. سارة أحمد',
        category: 'الحرف المتاحة',
      ),
      Course(
        title: 'دورة تطوير الذات',
        description: 'اكتشفي طاقتك الكاملة وطوري نفسك',
        imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
        duration: '8 ساعات',
        dateRange: '12 يونيو - 2 يوليو',
        instructor: 'أ. نورة محمد',
        category: 'التنمية البشرية',
      ),
      Course(
        title: 'دورة الطهي الصحي',
        description: 'إعداد وجبات صحية ومتوازنة لعائلتك',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        duration: '10 ساعات',
        dateRange: '20 يونيو - 10 يوليو',
        instructor: 'أ. فاطمة علي',
        category: 'الطهي',
      ),
    ];
  }
}

