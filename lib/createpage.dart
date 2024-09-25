import 'package:flutter/material.dart';
import 'package:flutter_crud/service/api.dart'; // Ensure this points to your API service
import 'package:flutter_crud/model/student_model.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool isEnrolled = false;

  var firstNameController = TextEditingController();
  var lastnameController = TextEditingController();
  var yearController = TextEditingController();
  String? selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5), // Light Lavender background
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // White background for the form container
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: firstNameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 60, 62, 63)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: lastnameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 60, 62, 63)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCourse,
                    items: <String>[
                      'BSIT',
                      'BSA',
                      'BSCE',
                      'BSED',
                      'BSN',
                      'BSBA',
                      'BSMLS'
                    ].map((String course) {
                      return DropdownMenuItem<String>(
                        value: course,
                        child: Text(course,
                            style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Course',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 60, 62, 63)),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCourse = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number, // Ensure numeric input
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Year',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 60, 62, 63)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enrolled',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      Switch(
                        value: isEnrolled,
                        onChanged: (bool value) {
                          setState(() {
                            isEnrolled = value;
                          });
                        },
                        activeColor: Colors.grey.shade300,
                        activeTrackColor: Colors.grey[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Validate input fields
                      if (firstNameController.text.isEmpty ||
                          lastnameController.text.isEmpty ||
                          yearController.text.isEmpty ||
                          selectedCourse == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill out all fields.'),
                          ),
                        );
                        return; // Exit if validation fails
                      }

                      var data = {
                        "firstname": firstNameController.text,
                        "lastname": lastnameController.text,
                        "year": int.tryParse(
                            yearController.text), // Convert year to int
                        "course": selectedCourse,
                        "enrolled": isEnrolled, // Send as boolean
                      };

                      print(
                          'Data to send: $data'); // Debugging line to see the data

                      try {
                        await Api.addStudent(
                            data); // Ensure Api.addStudent is implemented
                        Navigator.pop(context, true);
                      } catch (e) {
                        print('Error: $e'); // Print error for debugging
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error adding student: $e'),
                          ),
                        );
                      }
                    },
                    child: const Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 247, 242, 242),
                      backgroundColor: const Color.fromARGB(255, 22, 21, 21),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
