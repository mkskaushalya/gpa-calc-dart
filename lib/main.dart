import 'package:flutter/material.dart';

void main() {
  runApp(const GPACalculatorApp());
}

class GPACalculatorApp extends StatelessWidget {
  const GPACalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InputScreen(),
    );
  }
}

class Course {
  String name;
  int credit;
  String grade;

  Course({this.name = '', this.credit = 0, this.grade = ''});
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  final List<Course> _courses = [];
  final _formKey = GlobalKey<FormState>();

  final Map<String, double> gradeToGP = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'E': 0.7,
  };

  final List<String> grades = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'E',
  ];

  final List<int> credits = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    // Initialize with 3 empty courses
    for (int i = 0; i < 3; i++) {
      _courses.add(Course());
    }
  }

  void _addCourse() {
    setState(() {
      _courses.add(Course());
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Calculate GPA
      double totalGP = 0;
      int totalCredits = 0;
      for (var course in _courses) {
        double gp = gradeToGP[course.grade] ?? 0;
        totalGP += course.credit * gp;
        totalCredits += course.credit;
      }
      double gpa = totalCredits == 0 ? 0 : totalGP / totalCredits;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(gpa: gpa)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPA Calculator - Input Courses')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  return CourseInput(
                    course: _courses[index],
                    grades: grades,
                    credits: credits,
                    index: index,
                    onNameChanged: (value) {
                      _courses[index].name = value;
                    },
                    onCreditChanged: (value) {
                      _courses[index].credit = value ?? 0;
                    },
                    onGradeChanged: (value) {
                      _courses[index].grade = value ?? '';
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCourse,
                child: const Text('Add Another Course'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Calculate GPA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseInput extends StatelessWidget {
  final Course course;
  final List<String> grades;
  final List<int> credits;
  final int index;
  final Function(String) onNameChanged;
  final Function(int?) onCreditChanged;
  final Function(String?) onGradeChanged;

  const CourseInput({
    super.key,
    required this.course,
    required this.grades,
    required this.credits,
    required this.index,
    required this.onNameChanged,
    required this.onCreditChanged,
    required this.onGradeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Course Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a course name';
                }
                return null;
              },
              onChanged: onNameChanged,
            ),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Credit'),
              value: course.credit == 0 ? null : course.credit,
              items:
                  credits
                      .map(
                        (credit) => DropdownMenuItem(
                          value: credit,
                          child: Text('$credit'),
                        ),
                      )
                      .toList(),
              onChanged: onCreditChanged,
              validator: (value) {
                if (value == null || value == 0) {
                  return 'Please select a credit value';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Grade'),
              value: course.grade.isEmpty ? null : course.grade,
              items:
                  grades
                      .map(
                        (grade) =>
                            DropdownMenuItem(value: grade, child: Text(grade)),
                      )
                      .toList(),
              onChanged: onGradeChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a grade';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double gpa;

  const ResultScreen({super.key, required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPA Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your GPA is:', style: TextStyle(fontSize: 24)),
            Text(
              gpa.toStringAsFixed(2),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}