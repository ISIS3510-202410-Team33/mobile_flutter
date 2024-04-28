import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ventura_front/services/models/calification_model.dart';

class UserCalificationRepository {
  Future<void> sendCalification(Calification userCalification) async {
    final jsonData = userCalification.toJson();

    final response = await http.post(
      Uri.parse('/api/user_califications/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send rating');
    }
  }
}
