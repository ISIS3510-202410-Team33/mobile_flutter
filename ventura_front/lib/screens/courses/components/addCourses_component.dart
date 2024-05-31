import 'package:flutter/material.dart';
import "package:ventura_front/mvvm_components/observer.dart";
import "package:ventura_front/services/models/course_model.dart";
import "package:ventura_front/services/view_models/course_viewmodel.dart";

class AddCourses extends StatefulWidget {
  const AddCourses({Key? key}) : super(key: key);

  @override
  State<AddCourses> createState() => AddCoursesState();
}

class AddCoursesState extends State<AddCourses> implements EventObserver {
  late final Course course;
  final CoursesViewModel coursesViewModel = CoursesViewModel();
  TextEditingController nameController = TextEditingController();
  TextEditingController professorController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController scheduleController = TextEditingController();
  bool isSaveEnabled = false;

  void _showSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Course added successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Inicializamos el modelo de Course.
    course = Course(name: '', professor: '', room: '', schedule: '');
    // Añadir listeners a los controladores de texto
    nameController.addListener(_validateFields);
    professorController.addListener(_validateFields);
    roomController.addListener(_validateFields);
    scheduleController.addListener(_validateFields);
  }

  @override
  void dispose() {
    // Eliminar listeners de los controladores de texto
    nameController.removeListener(_validateFields);
    professorController.removeListener(_validateFields);
    roomController.removeListener(_validateFields);
    scheduleController.removeListener(_validateFields);
    nameController.dispose();
    professorController.dispose();
    roomController.dispose();
    scheduleController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      isSaveEnabled = nameController.text.isNotEmpty &&
                      professorController.text.isNotEmpty &&
                      roomController.text.isNotEmpty &&
                      scheduleController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => setState(() => course.name = value),
            ),
            SizedBox(height: 16),
            TextField(
              controller: professorController,
              decoration: InputDecoration(labelText: 'Professor'),
              onChanged: (value) => setState(() => course.professor = value),
            ),
            SizedBox(height: 16),
            TextField(
              controller: roomController,
              decoration: InputDecoration(labelText: 'Room'),
              onChanged: (value) => setState(() => course.room = value),
            ),
            SizedBox(height: 16),
            TextField(
              controller: scheduleController,
              decoration: InputDecoration(labelText: 'Schedule'),
              onChanged: (value) => setState(() => course.schedule = value),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: isSaveEnabled ? () {
                coursesViewModel.addCourse(course);
                _showSuccessMessage(context);
                // Limpiamos los campos de texto
                nameController.clear();
                professorController.clear();
                roomController.clear();
                scheduleController.clear();
                // Desactivar el botón "Save" después de guardar
                setState(() {
                  isSaveEnabled = false;
                });
              } : null,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void notify(ViewEvent event) {
    // TODO: implement notify
  }
}
