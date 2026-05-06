
import 'package:flutter/material.dart';
import 'package:wda/constant.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // بيانات ثابتة للتصميم فقط
  final List<Course> courses = [
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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title:const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.nightlight_round,
              color: Colors.white,
              size: 28,
            ),
             SizedBox(width: 8),
            Text(
              'جمعية تنمية المرأة',
              style: AppStyles.titleStyle,
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // شريط البحث
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.darkGreen,
            child: TextField(
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
                  onPressed: () {},
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
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseCard(
                  course: courses[index],
                  onTap: () {
                    // سيتم ربطها لاحقاً
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
