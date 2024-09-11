import 'package:flutter/material.dart';
import 'package:flutter_crud/model/student_model.dart';
import 'package:flutter_crud/services/api.dart';

class Updatepage extends StatefulWidget {
  final Student student;

  const Updatepage({super.key, required this.student});

  @override
  State<Updatepage> createState() => _UpdatepageState();
}

class _UpdatepageState extends State<Updatepage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late String _selectedCourse;
  late TextEditingController _yearController;
  late bool _enrolled;

  final List<String> _courses = [
    'BSIT',
    'BSA',
    'BSCE',
    'BSED',
    'BSN',
    'BSBA',
    'BSMLS'
  ];

  @override
  void initState() {
    super.initState();

    _firstnameController =
        TextEditingController(text: widget.student.firstname);
    _lastnameController = TextEditingController(text: widget.student.lastname);
    _selectedCourse = widget.student.course;
    _yearController = TextEditingController(text: widget.student.year);
    _enrolled = widget.student.enrolled ?? false;
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _updateStudent() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedData = {
        'firstname': _firstnameController.text,
        'lastname': _lastnameController.text,
        'course': _selectedCourse,
        'year': _yearController.text,
        'enrolled': _enrolled,
      };

      Api.updateStudent(widget.student.id, updatedData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Student updated successfully")),
        );

        Navigator.pop(context, true); // Pass true to indicate update
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update student: $error")),
        );
      });
    }
  }

  void _deleteStudent() async {
    // Show a loading indicator while deleting
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deleting Student'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Deleting, please wait...'),
            ],
          ),
        );
      },
    );

    try {
      await Api.deleteStudent(widget.student.id);
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student deleted successfully")),
      );
      Navigator.pop(context, true); // Pass true to indicate deletion
    } catch (error) {
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete student: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            ' ${widget.student.firstname} ${widget.student.lastname}'),
        backgroundColor: Color.fromARGB(255, 22, 21, 21),
      ),
      backgroundColor: Colors.grey[200], // Set greyish white background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstnameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(), // Add border
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 60, 62, 63)), 
                        borderRadius: BorderRadius.circular(8),
                      ),
                  filled: true,
                  fillColor: Colors.grey[300], // Set greyish white background
                ),
                style: TextStyle(color: Colors.grey[600]), // Set text color
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Add some spacing between fields
              TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(), // Add border
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 60, 62, 63)), 
                        borderRadius: BorderRadius.circular(8),
                      ),
                  filled: true,
                  fillColor: Colors.grey[300], // Set greyish white background
                ),
                style: TextStyle(color: Colors.grey[600]), // Set text color
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Add some spacing between fields
              DropdownButtonFormField<String>(
                value: _selectedCourse,
                decoration: InputDecoration(
                  labelText: 'Course',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(), // Add border
                  filled: true,
                  fillColor: Colors.grey[300], // Set greyish white background
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 60, 62, 63)), 
                        borderRadius: BorderRadius.circular(8),
                      ),
                ),
                style: TextStyle(color: Colors.grey[600]), // Set text color
                dropdownColor: Colors.grey[300], // Set dropdown menu background color
                items: _courses.map((course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Text(course, style: TextStyle(color: Colors.grey[600])),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCourse = value!;
                  });
                },
              ),
              SizedBox(height: 16), // Add some spacing between fields
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Year',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(), // Add border
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 60, 62, 63)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                  filled: true,
                  fillColor: Colors.grey[300], // Set greyish white background
                ),
                style: TextStyle(color: Colors.grey[600]), // Set text color
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Add some spacing between fields
              SwitchListTile(
                title: Text('Enrolled', style: TextStyle(color: Colors.grey[600])), // Set text color
                value: _enrolled,
                onChanged: (bool value) {
                  setState(() {
                    _enrolled = value;
                  });
                },
                activeColor:Colors.grey.shade300, 
                activeTrackColor: Colors.grey[600],
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade300,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    ElevatedButton(
                    onPressed: _deleteStudent,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Text color
                      backgroundColor: Colors.red, // Background color
                    ),
                    child: Text('Delete Student'),
                  ),
                  ElevatedButton(
                    onPressed: _updateStudent,
                    child: Text('Update Student', style: TextStyle(color: Colors.white)), // Set text color
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey[600], // Set text color
                      backgroundColor: Color.fromARGB(255, 22, 21, 21), // Background color
                    ),
                  ),
                
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
