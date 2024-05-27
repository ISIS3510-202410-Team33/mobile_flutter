import 'package:flutter/material.dart';
import "package:ventura_front/services/models/user_model.dart";
import "package:ventura_front/services/view_models/user_viewModel.dart";

class CourseView extends StatelessWidget {
  final UserModel _user = UserViewModel().user;
  final List<String> courses;

  CourseView({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $_user.name!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Here you can find the courses that you have added',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Search a course',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(courses[index]),
                    leading: Icon(Icons.book),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar el botón de agregar curso
                },
                child: Text('+ Add Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

