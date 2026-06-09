import '../model/student.dart';

class StudentService {
  // Demo mock data
  final List<Student> _students = [
    Student(id: '1', name: 'John Doe', email: 'john@example.com', rollNumber: 'CS101', department: 'Computer Science'),
    Student(id: '2', name: 'Jane Smith', email: 'jane@example.com', rollNumber: 'EE202', department: 'Electrical Engineering'),
  ];

  // Get all students
  List<Student> getStudents() {
    return _students;
  }

  // Add a new student
  void addStudent(Student student) {
    _students.add(student);
  }

  // Delete a student
  void deleteStudent(String id) {
    _students.removeWhere((student) => student.id == id);
  }
}