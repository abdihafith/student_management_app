class Student {
  final String id;
  final String name;
  final String email;
  final String rollNumber;
  final String department;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.department,
  });

  // Convert a Student object into a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rollNumber': rollNumber,
      'department': department,
    };
  }

  // Create a Student object from a Map (JSON)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      department: json['department'] ?? '',
    );
  }
}