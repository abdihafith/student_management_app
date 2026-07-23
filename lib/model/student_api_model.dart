class ApiStudent {
  final String id;
  final String name;
  final String course;
  final String admissionNumber;

  ApiStudent({
    required this.id,
    required this.name,
    required this.course,
    required this.admissionNumber,
  });

  // Factory constructor: Translates a JSON map into a Dart Object (Outcome 5)
  factory ApiStudent.fromJson(Map<String, dynamic> json) {
    return ApiStudent(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Student',
      course: json['company']?['name'] ?? 'IT Department', // Using placeholder text mapping
      admissionNumber: json['username'] ?? 'REG-0000',
    );
  }

  // Translates a Dart Object into a JSON map to send to the server (Outcome 5)
  Map<String, dynamic> toJson() => {
    'name': name,
    'course': course,
    'admission_number': admissionNumber,
  };
}