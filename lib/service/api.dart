import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud/model/student_model.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "https://bend-delta.vercel.app/api";

  // POST API
  static Future<void> addStudent(Map<String, dynamic> sdata) async {
    sdata['enrolled'] = sdata['enrolled'].toString();

    var url = Uri.parse(baseUrl + "add_student");

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(sdata),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print('Student added: $data');
      } else {
        print("Upload Failed: ${res.body}");
      }
    } catch (e) {
      debugPrint('Error adding student: ${e.toString()}');
    }
  }

  // GET API
  static Future<List<Student>> getPerson() async {
    List<Student> students = [];

    var url = Uri.parse(baseUrl + "get_student");

    try {
      final res = await http.get(url);
      print('GET Response: ${res.body}');

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print('Decoded Response: $data');

        if (data['students'] != null) {
          data['students'].forEach((element) {
            students.add(Student.fromJson(element));
          });
        }
      } else {
        print("Failed to fetch students: ${res.body}");
      }
    } catch (e) {
      debugPrint('Error fetching students: ${e.toString()}');
    }

    return students;
  }

  // PUT API - Update Student
  static Future<void> updateStudent(
      int id, Map<String, dynamic> updatedData) async {
    updatedData['enrolled'] = updatedData['enrolled']
        .toString();

    var url = Uri.parse(baseUrl + "update_student/$id");

    try {
      final res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print('Update Response: $data');
      } else {
        print("Update Failed: ${res.body}");
      }
    } catch (e) {
      debugPrint('Error updating student: ${e.toString()}');
    }
  }

  // DELETE API 
  static Future<void> deleteStudent(int id) async {
    var url = Uri.parse(baseUrl + "delete_student/$id");

    try {
      final res = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print('Delete Response: $data');
      } else {
        print("Delete Failed: ${res.body}");
      }
    } catch (e) {
      debugPrint('Error deleting student: ${e.toString()}');
    }
  }
}
