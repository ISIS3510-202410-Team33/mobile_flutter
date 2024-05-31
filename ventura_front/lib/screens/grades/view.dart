
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
  bool initialized = false;
  
  List<Course> filteredCourses = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCourses();
    searchController.addListener(_filterCourses);
  }

  void initTestCourses() {
     final List<Course> courses = [
    Course(id: 1, name: 'Mathematics', professor: 'John Doe', schedule: 'Mon 9:00 AM - 11:00 AM', room: "Sala 1"),
    Course(id: 2, name: 'Science', professor: 'Jane Smith', schedule: 'Tue 10:00 AM - 12:00 PM', room: "Sala 1"),
    Course(id: 3, name: 'History', professor: 'Jim Brown', schedule: 'Wed 1:00 PM - 3:00 PM', room: "Sala 1"),
    Course(id: 4, name: 'Art', professor: 'Sue Green', schedule: 'Thu 2:00 PM - 4:00 PM', room: "Sala 1"),
    Course(id: 5, name: 'Physical Education', professor: 'Tom White', schedule: 'Fri 8:00 AM - 10:00 AM', room: "Sala 1"),
    ];
    for (Course course in courses) {
      coursesViewModel.addCourse(course);
    }
    setState(() {
      initialized = true;
    });
    initCourses();
  }

  void initCourses() {
   
    coursesViewModel.getCourses((courses) {
      setState(() {
        this.courses = courses;
        filteredCourses = courses;
        if (courses.isEmpty){
          initialized = false;
        }
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

  Color getGradeColor(double grade) {
    if (grade >= 4) {
      return const Color(0xFFC3FF93);
    } 
    else if (grade >= 3) {
      return const Color(0xFFFFBF00);
    }
    else {
      return const Color(0xFFEE4E4E);
    }
  }



  void _addGrade(int courseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final nameController = TextEditingController();
        final gradeController = TextEditingController();
        final percentageController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Grade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
                maxLength: 15,
              ),
              TextField(
                controller: gradeController,
                decoration: const InputDecoration(labelText: 'Grade (0 - 5 scale)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: percentageController,
                decoration: const InputDecoration(labelText: 'Percentage (0 - 100 %)'),
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

                final courseIndex = courses.indexWhere((course) => course.id == courseId);
                final course = courses[courseIndex];

                try {
                  double pGrade = double.parse(gradeController.text);
                  double pPercentage = double.parse(percentageController.text);
                  double reestantPercentage  = 100 - course.grades.fold(0, (previousValue, element) => previousValue + element.percentage);

                  if (pPercentage < 0 || pPercentage > 100) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('The percentage must be between 0 and 100'),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else if (pPercentage > reestantPercentage) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('The percentage is greater than the remaining percentage ($reestantPercentage %) to pass the course'),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else if (pGrade < 0 || pGrade > 5) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('The grade must be between 0 and 5'),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }

                  else if (nameController.text.isEmpty || gradeController.text.isEmpty || percentageController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('All fields are required'),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }

                  else {   
                    setState(() {
                      final newGrade = Grade(
                        courseId: courseId,
                        grade: double.parse(gradeController.text),
                        name: nameController.text,
                        percentage: pPercentage
                      );
                      gradesViewModel.addGrade(newGrade);

                      final updatedGrades = List<Grade>.from(course.grades)..add(newGrade);
                      courses[courseIndex] = course.copyWith(grades: updatedGrades);
                      filteredCourses = List.from(courses);
                    });
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('The grade and percentage must be filled in and must be numbers.'),
                        actions: [
                          TextButton(
                            child: const Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } 
                
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!initialized) {
              initTestCourses();

            }
          }, // Cambia el icono según tu preferencia
          backgroundColor: const Color(0xFFBBE2EC),
          child: const Icon(Icons.add_chart_sharp), // Cambia el color de fondo según tu preferencia
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
              const SizedBox(height: 30),
              courses.isEmpty ? const SizedBox() : 
                FutureBuilder<double>(
                  future: gradesViewModel.getAverage(),
                  builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.align_vertical_bottom_rounded, color: Colors.white,),
                          const SizedBox(width: 10,),
                          const Text(
                            'Current semester average:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                              ),
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: getGradeColor(snapshot.data!),
                              ),
                          )
                      ],);  
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              const SizedBox(height: 20),

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
                                          title: Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  grade.name,
                                                  style:  const TextStyle(color: Colors.white),
                                                ),
                                                Text(
                                                  '${grade.grade} / 5',
                                                  style:  TextStyle(color: getGradeColor(grade.grade)),
                                                ),
                                                Text(
                                                  '${grade.percentage} %',
                                                  style:  const TextStyle(color: Color(0xFFBBE2EC)),
                                                ),
                                              ],
                                              )
                                            )
                                        
                                          
                                        );
                                      }).toList(),

                                    ),
                                ],)
                              )
                            
                          ),
                          const SizedBox(height: 15),
                          filteredCourses[index].grades.isEmpty ? const SizedBox() :
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF31363F), // Color de fondo personalizado
                              borderRadius: BorderRadius.circular(20), // Borde redondeado
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                              child:  
                              
                              Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  
                                  children: [
                                    FutureBuilder(
                                      future: gradesViewModel.getGradeToPassCourse(filteredCourses[index].id!), builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {

                                          if (snapshot.data!.isInfinite || snapshot.data == 0 ) {
                                            return const Text(
                                              'You have finished the course',

                                              style: TextStyle(color: Colors.white),
                                            );
                                          } 
                                          else if (snapshot.data == -1) {
                                            return const Text(
                                              'You already passed the course',

                                              style: TextStyle(color: Color(0xFFC3FF93)),
                                            );
                                          }
                                          
                                          else {
                                            return Text(
                                              'You need ${snapshot.data} ',
                                              style: const TextStyle(color: Colors.white),
                                            );
                                          }
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),
                                      
                                  ],    
                                ),
                                FutureBuilder(
                                      future: gradesViewModel.getFinalGradeByCourseId(filteredCourses[index].id!), builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {

                                          if (snapshot.data!.isInfinite || snapshot.data == 0 ) {
                                            return const SizedBox();
                                          } else {
                                            return Text(
                                              'Your final grade is ${snapshot.data}',
                                              style: TextStyle(color: getGradeColor(snapshot.data!)),
                                            );
                                          }
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),
                                FutureBuilder(
                                      future: gradesViewModel.getReestantPercentageByCourseId(filteredCourses[index].id!), builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                        
                                          if (snapshot.data == 0) {
                                            return const SizedBox();
                                          } else {
                                            return Text(
                                              'in the ${snapshot.data}% to pass the course',
                                              style: const TextStyle(color: Colors.white),
                                            );
                                          }
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),
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
