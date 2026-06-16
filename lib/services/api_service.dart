import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/student_api_model.dart';

class ApiService {
  // Replace with your designated server endpoint or classroom lab address
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/users';

  // 1. GET Request: Fetches data asynchronously from the server (Outcome 3 & 4)
  Future<List<ApiStudent>> fetchStudentsFromServer() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Decode raw string body into a dynamic Dart list
        List<dynamic> jsonBody = json.decode(response.body);
        return jsonBody.map((student) => ApiStudent.fromJson(student)).toList();
      } else {
        throw Exception('Server error code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Network communication failed: $error');
    }
  }

  // 2. POST Request: Submits a new record over the web (Outcome 3 & 4)
  Future<bool> uploadStudentRecord(ApiStudent student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(student.toJson()),
      );

      // 201 means "Created" successfully on web servers
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}