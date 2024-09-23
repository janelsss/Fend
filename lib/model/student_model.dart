class Student {
  int id;
  String firstname;
  String lastname;
  String course;
  String year;
  bool? enrolled;

  Student({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.course,
    required this.year,
    this.enrolled,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      course: json['course'] ?? '',
      year: json['year'] != null ? json['year'].toString() : '', // Updated to handle null
      enrolled: json['enrolled'] is bool ? json['enrolled'] : (json['enrolled'] == 'true'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'course': course,
      'year': year,
      'enrolled': enrolled, // Directly using the boolean value
    };
  }
}
