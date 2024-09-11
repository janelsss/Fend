import 'package:flutter/material.dart';
import 'package:flutter_crud/model/student_model.dart';
import 'package:flutter_crud/services/api.dart';
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
      studentsFuture = Api.getPerson(); // Refresh data
    });
  }

  Future<void> _deleteStudent(int id) async {
    try {
      await Api.deleteStudent(id);
      _refreshData(); // Refresh data to reflect deletion
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
      backgroundColor: Color(0xFFF5F5F5), // Greyish white background
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
                      foregroundColor: Colors.white, // Text color
                      backgroundColor: Color.fromARGB(255, 253, 254, 254), // Soft Blue
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
                  key: Key(sdata[index].id.toString()), // Unique key for each item
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await _deleteStudent(sdata[index].id); // Call delete function
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
                          builder: (context) => Updatepage(student: sdata[index]),
                        ),
                      ).then((updated) {
                        if (updated == true) {
                          _refreshData(); // Refresh data if updated
                        }
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(Icons.person_2_rounded, size: 35),
                        title: Text("First Name: ${sdata[index].firstname}", style: TextStyle(color: Colors.white)),
                        subtitle: Text("Last Name: ${sdata[index].lastname}", style: TextStyle(color: Colors.white)),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Course: ${sdata[index].course}", style: TextStyle(color:Colors.white)),
                            Text("Year: ${sdata[index].year}", style: TextStyle(color: Colors.white)),
                            Text(
                                "Enrolled: ${sdata[index].enrolled == true ? 'Yes' : 'No'}",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "NO DATA FOUND !",
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CreatePage()),
          ).then((result) {
            if (result == true) {
              _refreshData(); // Refresh data if created
            }
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Add New',
        backgroundColor: Color.fromARGB(255, 22, 21, 21),
        foregroundColor: Colors.white, // Soft Blue
      ),
    );
  }
}
