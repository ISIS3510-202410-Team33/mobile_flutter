
import 'package:flutter/material.dart';
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/services/models/grade_model.dart';
import 'package:ventura_front/services/models/course_model.dart';

class GradesView extends StatefulWidget {
  const GradesView({super.key});

  @override
  State<GradesView> createState() => GradesViewState();
}

class GradesViewState extends State<GradesView> implements EventObserver {
  final List<Course> courses = [
    Course(id: 1, name: 'Mathematics', professor: 'John Doe', description: 'Mon 9:00 AM - 11:00 AM', date: 0),
    Course(id: 2, name: 'Science', professor: 'Jane Smith', description: 'Tue 10:00 AM - 12:00 PM', date: 0),
    Course(id: 3, name: 'History', professor: 'Jim Brown', description: 'Wed 1:00 PM - 3:00 PM', date: 0),
    Course(id: 4, name: 'Art', professor: 'Sue Green', description: 'Thu 2:00 PM - 4:00 PM', date: 0),
    Course(id: 5, name: 'Physical Education', professor: 'Tom White', description: 'Fri 8:00 AM - 10:00 AM', date: 0),
  ];
  List<Course> filteredCourses = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCourses = courses;
    searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCourses);
    searchController.dispose();
    super.dispose();
  }

  void _filterCourses() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredCourses = courses.where((course) {
        return course.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addGrade(int courseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final nameController = TextEditingController();
        final gradeController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Grade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: gradeController,
                decoration: const InputDecoration(labelText: 'Grade'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  final courseIndex = courses.indexWhere((course) => course.id == courseId);
                  final course = courses[courseIndex];
                  final newGrade = Grade(
                    id: course.grades.length + 1,
                    courseId: courseId,
                    grade: double.parse(gradeController.text),
                    name: nameController.text,
                  );

                  final updatedGrades = List<Grade>.from(course.grades)..add(newGrade);
                  courses[courseIndex] = course.copyWith(grades: updatedGrades);
                  filteredCourses = List.from(courses);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void notify(ViewEvent event) {
    // TODO: implement notify
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF16171B), Color(0xFF353A40)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search course...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const SizedBox(height: 10),
              const Text(
                'Check your grades',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListView.builder(
                    itemCount: filteredCourses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTile(
                        title: Text(
                          filteredCourses[index].name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF353A40).withOpacity(0.1),
                        collapsedBackgroundColor: const Color(0xFF353A40).withOpacity(0.1),
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        collapsedTextColor: Colors.white,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person, color: Colors.white),
                            title: Text(
                              'professor: ${filteredCourses[index].professor}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.description, color: Colors.white),
                            title: Text(
                              'description: ${filteredCourses[index].description}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey, // Color del separador
                            thickness: 1,       // Grosor del separador
                            height: 20,         // Altura del separador
                            indent: 20,         // Sangría del inicio del separador
                            endIndent: 20,      // Sangría del final del separador
                          ),
                          filteredCourses[index].grades.isEmpty
                              ? const Text(
                                    'No grades yet',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      ),
                                    
                                  )
                              : const Text(
                                  'Grades',
                                  style: TextStyle(
                                    color: Colors.white, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    ),
                                ),
                          const SizedBox(height: 15),
                          Column(
                            children: filteredCourses[index].grades.map((grade) {
                              return ListTile(
                                title: Text(
                                  '${grade.name}: ${grade.grade}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                
                              );
                            }).toList(),

                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF31363F), // Color de fondo personalizado
                              borderRadius: BorderRadius.circular(40), // Borde redondeado
                            ),
                            child: TextButton(
                              onPressed: () {
                                _addGrade(filteredCourses[index].id);
                              },
                              child: 
                              const Padding(
                                padding: EdgeInsets.only(left: 15, right: 15), 
                                child:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, color: Colors.white), // Icono con color blanco
                                    SizedBox(width: 8), // Espacio entre el icono y el texto
                                    Text(
                                      'Agregar', // Tu texto aquí
                                      style: TextStyle(
                                        // Estilo del texto
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),  
                              )
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
