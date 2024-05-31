import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ventura_front/services/models/schedule_model.dart';

class TaskCalendarPage extends StatefulWidget {
  @override
  _TaskCalendarPageState createState() => _TaskCalendarPageState();
}

class _TaskCalendarPageState extends State<TaskCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Schedule>> _tasksByDate = {};

  String _taskTitle = '';
  String _taskDescription = '';

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadTasks();
  }

  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      setState(() {
        _tasksByDate = Map.fromIterable(
          (json.decode(tasksJson) as List),
          key: (task) => DateTime.parse(task['fecha']),
          value: (task) =>
              (task['tasks'] as List).map((t) => Schedule.fromJson(t)).toList(),
        );
      });
    }
  }

  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'tasks',
        json.encode(_tasksByDate.entries
            .map((entry) => {
                  'fecha': entry.key.toIso8601String(),
                  'tasks': entry.value.map((task) => task.toJson()).toList(),
                })
            .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            headerVisible: false,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.white),
              holidayTextStyle: TextStyle(color: Colors.white),
              defaultTextStyle: TextStyle(color: Colors.white),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 111, 112, 20),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 168, 92, 21),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: const HeaderStyle(
              titleTextStyle: TextStyle(color: Colors.white),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.white),
              weekdayStyle: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 20),
                Text(
                  'Tasks for the selected date',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 20),
                Column(
                  children: _tasksByDate[_selectedDay] != null
                      ? _tasksByDate[_selectedDay]!
                          .map(
                            (task) => Container(
                              child: CheckboxListTile(
                                title: Text(
                                  task.titulo,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  task.descripcion,
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: task.completed,
                                onChanged: (value) {
                                  setState(() {
                                    task.completed = value!;
                                    _saveTasks();
                                  });
                                },
                              ),
                            ),
                          )
                          .toList()
                      : [],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add Task'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) => _taskTitle = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) => _taskDescription = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_taskTitle.isNotEmpty && _taskDescription.isNotEmpty) {
                final newTask = Schedule(
                  id: _tasksByDate[_selectedDay] != null
                      ? _tasksByDate[_selectedDay]!.length + 1
                      : 1,
                  titulo: _taskTitle,
                  descripcion: _taskDescription,
                  completed: false,
                );
                setState(() {
                  if (_tasksByDate[_selectedDay] == null) {
                    _tasksByDate[_selectedDay!] = [];
                  }
                  _tasksByDate[_selectedDay!]!.add(newTask);
                  _saveTasks();
                  _taskTitle = '';
                  _taskDescription = '';
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
