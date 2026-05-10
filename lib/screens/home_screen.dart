import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/course.dart';
import '../constant.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';
import 'admin_login_dialog.dart';

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
  bool _showFavoritesOnly = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);

    List<Course> loadedCourses;

    if (_showFavoritesOnly) {
      loadedCourses = await DatabaseHelper.instance.getFavoriteCourses();
    } else {
      loadedCourses = await DatabaseHelper.instance.getAllCourses();
    }

    if (loadedCourses.isEmpty && !_showFavoritesOnly) {
      final sampleCourses = Course.getSampleCourses();
      for (var course in sampleCourses) {
        await DatabaseHelper.instance.insertCourse(course);
      }
      loadedCourses = await DatabaseHelper.instance.getAllCourses();
    }

    setState(() {
      courses = loadedCourses;
      filteredCourses = loadedCourses;
      _isLoading = false;
    });
  }

  void _searchCourses(String query) {
    setState(() {
      filteredCourses = courses.where((course) {
        return course.title.contains(query) ||
            course.description.contains(query) ||
            course.instructor.contains(query);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showFavoritesOnly = (index == 2);
    });
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreen,
        ),
      )
          : Column(
        children: [

          if (!_showFavoritesOnly)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.darkGreen,
              child: TextField(
                controller: _searchController,
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

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!_showFavoritesOnly)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        filteredCourses = courses;
                        _searchController.clear();
                      });
                    },
                    child: const Text(
                      'عرض الكل',
                      style: TextStyle(color: AppColors.primaryGreen),
                    ),
                  ),
                Text(
                  _showFavoritesOnly ? 'المفضلة ❤️' : 'الدورات المتاحة',
                  style: AppStyles.headingStyle,
                ),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadCourses,
              color: AppColors.primaryGreen,
              child: filteredCourses.isEmpty
                  ? Center(
                child: Text(
                  _showFavoritesOnly
                      ? 'لا توجد دورات مفضلة ❤️'
                      : 'لا توجد دورات',
                  style: const TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
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
                            onFavoriteChanged: _loadCourses,
                          ),
                        ),
                      ).then((_) => _loadCourses());
                    },
                  );
                },
              ),
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AdminLoginDialog(),
          );
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

