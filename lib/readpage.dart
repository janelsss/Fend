import 'package:flutter/material.dart';
import 'package:flutter_crud/model/student_model.dart';
import 'package:flutter_crud/service/api.dart';
import 'package:flutter_crud/updatepage.dart';
import 'package:flutter_crud/createpage.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  late Future<List<Student>> studentsFuture;

  @override
  void initState() {
    super.initState();
    studentsFuture = Api.getPerson();
  }

  Future<void> _refreshData() async {
    setState(() {
      studentsFuture = Api.getPerson();
    });
  }

  Future<void> _deleteStudent(String id) async {
    // Change int to String
    try {
      await Api.deleteStudent(id);
      _refreshData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student deleted successfully")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete student: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: FutureBuilder<List<Student>>(
        future: studentsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${snapshot.error}"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 253, 254, 254),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Student> sdata = snapshot.data!;

            return ListView.builder(
              itemCount: sdata.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(sdata[index].id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await _deleteStudent(sdata[index].id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Student deleted successfully")),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Updatepage(student: sdata[index]),
                        ),
                      ).then((updated) {
                        if (updated == true) {
                          _refreshData();
                        }
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(Icons.person_2_rounded, size: 35),
                        title: Text("First Name: ${sdata[index].firstname}"),
                        subtitle: Text("Last Name: ${sdata[index].lastname}"),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Course: ${sdata[index].course}"),
                            Text("Year: ${sdata[index].year}"),
                            Text(
                                "Enrolled: ${sdata[index].enrolled == true ? 'Yes' : 'No'}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Student Found!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(builder: (_) => CreatePage()),
          )
              .then((result) {
            if (result == true) {
              _refreshData();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
