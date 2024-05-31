import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/screens/courses/components/addCourses_component.dart';
import 'package:ventura_front/screens/courses/components/coursesDetails_component.dart';
import 'package:ventura_front/services/models/course_model.dart';
import 'package:ventura_front/services/view_models/course_viewmodel.dart';

class CoursesView extends StatefulWidget {
  const CoursesView({Key? key}) : super(key: key);

  @override
  State<CoursesView> createState() => CoursesViewState();
}

class CoursesViewState extends State<CoursesView> implements EventObserver {
  final CoursesViewModel coursesViewModel = CoursesViewModel();
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  Map<String, int> clickCounts = {};
  Course? favoriteCourse;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _loadFavoriteCourse();
    searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCourses);
    searchController.dispose();
    super.dispose();
  }

  void _loadCourses() {
    coursesViewModel.getCourses((courses) {
      setState(() {
        this.courses = courses;
        filteredCourses = courses;
      });
    });
  }

  void _loadFavoriteCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoriteCourseName = prefs.getString('favoriteCourse');
    if (favoriteCourseName != null) {
      setState(() {
        favoriteCourse = courses.firstWhere((course) => course.name == favoriteCourseName, orElse: () => courses.first);
      });
    }
  }

  void _saveFavoriteCourse(Course course) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('favoriteCourse', course.name);
  }

  void _filterCourses() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredCourses = query.isEmpty
          ? courses
          : courses.where((course) => course.name.toLowerCase().contains(query)).toList();
    });
  }

  void _navigateToAddCourse(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCourses()),
    );
  }

  void _navigateToCourseDetails(Course course) {
    setState(() {
      clickCounts.update(course.name, (value) => value + 1, ifAbsent: () => 1);
      favoriteCourse = _getMostClickedCourse();
      _saveFavoriteCourse(favoriteCourse!);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetails(
          course: course,
          bannerUrl: 'https://mibanner.uniandes.edu.co/',
          bloqueNeonUrl: 'https://bloqueneon.uniandes.edu.co/',
          pdfUrl: 'https://uniandes.edu.co/sites/default/files/asset/document/Acerca-de-uniandes_0.pdf',
        ),
      ),
    );
  }

  Course _getMostClickedCourse() {
    int maxClicks = 0;
    Course? mostClickedCourse;
    clickCounts.forEach((courseName, clicks) {
      if (clicks > maxClicks) {
        maxClicks = clicks;
        mostClickedCourse = courses.firstWhere((course) => course.name == courseName);
      }
    });
    return mostClickedCourse!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadCourses();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Here you can find the courses you have added',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Courses',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(course.name),
                          subtitle: Text(course.professor),
                          trailing: favoriteCourse != null && favoriteCourse!.name == course.name ? Icon(Icons.favorite) : null,
                          onTap: () => _navigateToCourseDetails(course),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _navigateToAddCourse(context);
                    },
                    child: Text('+ ADD COURSE'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void notify(ViewEvent event) {
    // TODO: implement notify
  }
}
