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
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      course: json['course'],
      year: json['year'],
      enrolled: json['enrolled'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'course': course,
      'year': year,
      'enrolled': enrolled.toString(),
    };
  }
}
