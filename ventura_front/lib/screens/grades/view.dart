
import 'package:flutter/material.dart';
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/services/models/grade_model.dart';
import 'package:ventura_front/services/models/course_model.dart';
import 'package:ventura_front/services/view_models/course_viewmodel.dart';
import 'package:ventura_front/services/view_models/grades_viewmodel.dart';

class GradesView extends StatefulWidget {
  const GradesView({super.key});

  @override
  State<GradesView> createState() => GradesViewState();
}

class GradesViewState extends State<GradesView> implements EventObserver {
  List<Course> courses = [];

  final GradesViewModel gradesViewModel = GradesViewModel();
  final CoursesViewModel coursesViewModel = CoursesViewModel();
  
  List<Course> filteredCourses = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCourses();
    searchController.addListener(_filterCourses);
  }

  void initCourses() {
    //final List<Course> courses = [
    //Course(id: 1, name: 'Mathematics', professor: 'John Doe', schedule: 'Mon 9:00 AM - 11:00 AM', room: "Sala 1"),
    //Course(id: 2, name: 'Science', professor: 'Jane Smith', schedule: 'Tue 10:00 AM - 12:00 PM', room: "Sala 1"),
    //Course(id: 3, name: 'History', professor: 'Jim Brown', schedule: 'Wed 1:00 PM - 3:00 PM', room: "Sala 1"),
    //Course(id: 4, name: 'Art', professor: 'Sue Green', schedule: 'Thu 2:00 PM - 4:00 PM', room: "Sala 1"),
    //Course(id: 5, name: 'Physical Education', professor: 'Tom White', schedule: 'Fri 8:00 AM - 10:00 AM', room: "Sala 1"),
    //];
    //for (Course course in courses) {
    //coursesViewModel.addCourse(course);
    //}

    coursesViewModel.getCourses((courses) {
      setState(() {
        this.courses = courses;
        filteredCourses = courses;
      });
      initGrades();
    });
  }

  void initGrades(){
    print(courses.length);
    for (Course course in courses) {
      gradesViewModel.getGradesByCourseId(course.id!, (grades) {
        for (Grade grade in grades) {
          print(grade.id);
        }
        setState(() {
          final courseIndex = courses.indexWhere((c) => c.id == course.id);
          courses[courseIndex] = course.copyWith(grades: grades);
          filteredCourses = List.from(courses);
        });
      });
    }
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
                    courseId: courseId,
                    grade: double.parse(gradeController.text),
                    name: nameController.text,
                  );
                  gradesViewModel.addGrade(newGrade);

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
                title:
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.grading, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                    'Check your grades',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      ),
                  ),
                ],), 
                

                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const SizedBox(height: 10),
              Padding(padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search course...',
                    hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFCCCCCC)),
                    filled: true,
                    fillColor: const Color(0xFF31363F), // Color de fondo gris claro
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0), // Borde redondeado
                      borderSide: BorderSide.none, // Sin borde
                    ),
                  ),
                  style: const TextStyle(color: Colors.white), // Cambié el color del texto a negro para mejor visibilidad
                )
              ),
              const SizedBox(height: 10),
              courses.isEmpty
                ? const Column (
                    children: [
                      SizedBox(height: 30),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Icon(Icons.error_outline_outlined, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                        'You have not yet enrolled in a course',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                          ),
                      ),
                    ],)]
                  )
                :
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
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        collapsedTextColor: Colors.white,
                        children: [
                          ListTile(
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                            leading: const Icon(Icons.person, color: Colors.white),
                            title: Text(
                              'Teacher: ${filteredCourses[index].professor}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                            leading: const Icon(Icons.description, color: Colors.white),
                            title: Text(
                              'Schedule: ${filteredCourses[index].schedule}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF31363F), // Color de fondo personalizado
                              borderRadius: BorderRadius.circular(20), // Borde redondeado
                            ),
                            child: 
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                              child: 
                                Column(children: [
                                  filteredCourses[index].grades.isEmpty
                                  ? const Text(
                                        'No grades yet',
                                        style: TextStyle(
                                          letterSpacing: 2,
                                          color: Colors.white, 
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          wordSpacing: 4
                                          ),
                                        
                                      )
                                  : const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Your Grades',
                                      style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white, 
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        wordSpacing: 4
                                        ),
                                    ),
                                    ) 
                                  ,
                                    Column(
                                      children: filteredCourses[index].grades.map((grade) {
                                        return ListTile(
                                          leading: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.white, size: 15,),
                                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                          title: Text(
                                            '${grade.name}: ${grade.grade}',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        
                                          
                                        );
                                      }).toList(),

                                    ),
                                ],)
                              )
                            
                          ),
                          const SizedBox(height: 15),
                          

                         
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF344C64), // Color de fondo personalizado
                              borderRadius: BorderRadius.circular(40), // Borde redondeado
                            ),
                            child: TextButton(
                              onPressed: () {
                                _addGrade(filteredCourses[index].id!);
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
                                      'Add grade', // Tu texto aquí
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
