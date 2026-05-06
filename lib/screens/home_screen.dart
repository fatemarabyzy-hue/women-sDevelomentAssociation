
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart';
import '../constant.dart';
import '../widgets/course_card.dart';
import 'admin_login_dialog.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // ✅ تحميل من JSON
  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);

    try {
      final String jsonString = await rootBundle.loadString('assets/data/courses_data.json');
      final List<Course> loadedCourses = Course.fromJsonList(jsonString);

      setState(() {
        courses = loadedCourses;
        filteredCourses = loadedCourses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _searchCourses(String query) {
    setState(() {
      filteredCourses = courses.where((course) {
        return course.title.contains(query) ||
            course.description.contains(query);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AdminLoginDialog(),
              );
            },
          ),
        ],
        backgroundColor: AppColors.darkGreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.groups_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'جمعية تنمية المرأة',
              style: AppStyles.titleStyle,
            ),
          ],
        ),
      ),

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreen,
        ),
      )
          : Column(
        children: [
          // شريط البحث
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.darkGreen,
            child: TextField(
              onChanged: _searchCourses,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن دورة...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          // عنوان القسم
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      filteredCourses = courses;
                    });
                  },
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(color: AppColors.primaryGreen),
                  ),
                ),
                const Text(
                  'الدورات المتاحة',
                  style: AppStyles.headingStyle,
                ),
              ],
            ),
          ),

          // قائمة الدورات
          Expanded(
            child: ListView.builder(
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                return CourseCard(
                  course: filteredCourses[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailScreen(
                          course: filteredCourses[index],
                        ),
                      ),
                    );
                  },

                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'الدورات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

