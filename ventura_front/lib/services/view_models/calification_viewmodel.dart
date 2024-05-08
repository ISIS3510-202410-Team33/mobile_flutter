import 'package:flutter/material.dart';
import 'package:ventura_front/services/models/calification_model.dart';
import 'package:ventura_front/services/repositories/calification_repository.dart';
import 'package:ventura_front/mvvm_components/viewmodel.dart';

class CalificationViewModel extends EventViewModel {
  int _selectedStars = 0;
  TextEditingController _descriptionController = TextEditingController();

  int _calificationIdCounter = 0;

  int get _generateCalificationId {
    return ++_calificationIdCounter;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Building Rating')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  icon: Icon(
                    i <= _selectedStars ? Icons.star : Icons.star_border,
                    color: const Color.fromARGB(255, 28, 150, 206),
                  ),
                  onPressed: () {
                      _selectedStars = i;
                    ;
                  },
                ),
            ],
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Enter your comment'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              sendCalification(userId: 1, locationId: 2);
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> sendCalification(
      {required int userId, required int locationId}) async {
    final userCalification = Calification(
      id: _generateCalificationId,
      calification: _selectedStars,
      description: _descriptionController.text,
      date: DateTime.now().toString(),
      user: userId,
      collegeLocation: locationId,
    );

    final repository = UserCalificationRepository();
    try {
      await repository.sendCalification(userCalification);
    } catch (e) {
      throw Exception('Failed to send rating');
    }
  }
  
}
