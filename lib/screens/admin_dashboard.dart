
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/course.dart';
import '../constant.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _durationController = TextEditingController();
  final _dateController = TextEditingController();
  final _instructorController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();

  List<Course> courses = [];
  bool _isEditing = false;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _dateController.dispose();
    _instructorController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    final loadedCourses = await DatabaseHelper.instance.getAllCourses();
    setState(() {
      courses = loadedCourses;
    });
  }

  void _clearForm() {
    _titleController.clear();
    _descController.clear();
    _durationController.clear();
    _dateController.clear();
    _instructorController.clear();
    _imageUrlController.clear();
    _categoryController.clear();
    setState(() {
      _isEditing = false;
      _editingId = null;
    });
  }

  void _editCourse(Course course) {
    setState(() {
      _isEditing = true;
      _editingId = course.id;
      _titleController.text = course.title;
      _descController.text = course.description;
      _durationController.text = course.duration;
      _dateController.text = course.dateRange;
      _instructorController.text = course.instructor;
      _imageUrlController.text = course.imageUrl;
      _categoryController.text = course.category;
    });
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: _isEditing ? _editingId : null,
        title: _titleController.text,
        description: _descController.text,
        imageUrl: _imageUrlController.text.isEmpty
            ? 'https://via.placeholder.com/400'
            : _imageUrlController.text,
        duration: _durationController.text,
        dateRange: _dateController.text,
        instructor: _instructorController.text,
        category: _categoryController.text.isEmpty
            ? 'عام'
            : _categoryController.text,
      );

      if (_isEditing) {
        await DatabaseHelper.instance.updateCourse(course);
      } else {
        await DatabaseHelper.instance.insertCourse(course);
      }

      await _loadCourses();
      _clearForm();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'تم تحديث الدورة بنجاح' : 'تم إضافة الدورة بنجاح',
          ),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    }
  }

  Future<void> _deleteCourse(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الدورة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteCourse(id);
              await _loadCourses();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الدورة بنجاح'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title: const Text('لوحة تحكم الإدارة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildForm(),
                ),
                Expanded(
                  flex: 3,
                  child: _buildCourseList(),
                ),
              ],
            );
          } else {
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'النموذج', icon: Icon(Icons.edit)),
                      Tab(text: 'القائمة', icon: Icon(Icons.list)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [

                        _buildForm(),
                        _buildCourseList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'تعديل دورة' : 'إضافة دورة جديدة',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                controller: _titleController,
                label: 'اسم الدورة',
                icon: Icons.title,
              ),
              _buildTextField(
                controller: _descController,
                label: 'وصف الدورة',
                icon: Icons.description,
                maxLines: 3,
              ),
              _buildTextField(
                controller: _durationController,
                label: 'المدة',
                icon: Icons.access_time,
              ),
              _buildTextField(
                controller: _dateController,
                label: 'المواعيد',
                icon: Icons.calendar_today,
              ),

              _buildTextField(
                controller: _instructorController,
                label: 'المحاضر',
                icon: Icons.person,
              ),
              _buildTextField(
                controller: _categoryController,
                label: 'التصنيف',
                icon: Icons.category,
              ),
              _buildTextField(
                controller: _imageUrlController,
                label: 'رابط الصورة',
                icon: Icons.image,
                isOptional: true,
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'تحديث' : 'حفظ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              if (_isEditing) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _clearForm,
                  child: const Text('إلغاء التعديل'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'الدورات الحالية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: courses.isEmpty
                ? const Center(
              child: Text(
                'لا توجد دورات',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteCourse(course.id!),

                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.primaryGreen,
                          ),
                          onPressed: () => _editCourse(course),
                        ),
                      ],
                    ),
                    title: Text(
                      course.title,
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      '${course.duration} | ${course.instructor}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.grey),
          suffixIcon: Icon(icon, color: AppColors.primaryGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryGreen,
              width: 2,
            ),          ),
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'الرجاء إدخال $label';
          }
          return null;
        },
      ),
    );
  }
}



