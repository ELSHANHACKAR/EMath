import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Student> students = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحه اصلی'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StudentPage(student: students[index])),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newStudent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewStudentPage()),
          );

          if (newStudent != null) {
            setState(() {
              students.add(newStudent);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NewStudentPage extends StatefulWidget {
  @override
  _NewStudentPageState createState() => _NewStudentPageState();
}

class _NewStudentPageState extends State<NewStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final sessionCountController = TextEditingController();
  final payableController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ایجاد دانش آموز جدید'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'اسم دانش آموز'),
            ),
            TextFormField(
              controller: numberController,
              decoration: InputDecoration(labelText: 'شماره دانش آموز'),
            ),
            TextFormField(
              controller: sessionCountController,
              decoration: InputDecoration(labelText: 'تعداد جلسه'),
            ),
            TextFormField(
              controller: payableController,
              decoration: InputDecoration(labelText: 'قابل پرداخت'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(
                    context,
                    Student(
                      name: nameController.text,
                      number: int.parse(numberController.text),
                      sessionCount: int.parse(sessionCountController.text),
                      sessionLinks: [],
                      payable: int.parse(payableController.text),
                      paid: 0,
                    ),
                  );
                }
              },
              child: Text('ایجاد کلاس'),
            ),
          ],
        ),
      ),
    );
  }
}

class Student {
  final String name;
  final int number;
  int sessionCount;
  final List<Session> sessionLinks;
  int payable;
  int paid;

  Student(
      {required this.name,
      required this.number,
      required this.sessionCount,
      required this.sessionLinks,
      required this.payable,
      required this.paid});
}

class Session {
  final String link;
  final DateTime dateTime;

  Session({required this.link, required this.dateTime});
}

class StudentPage extends StatefulWidget {
  final Student student;

  StudentPage({Key? key, required this.student}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _formKey = GlobalKey<FormState>();
  final linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.name),
      ),
      body: Center(
        child: Column(
          children: [
            widget.student.sessionCount > 0
                ? Text('تعداد جلسات باقی مانده: ${widget.student.sessionCount}')
                : Text('کلاس تمام شده'),
            widget.student.payable - widget.student.paid > 0
                ? Text(
                    'هزینه مانده: ${widget.student.payable - widget.student.paid}')
                : Text('کامل پرداخت شده'),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: linkController,
                    decoration: InputDecoration(labelText: 'لینک آموزش'),
                  ),
                  ElevatedButton(
                    onPressed: widget.student.sessionCount > 0
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                widget.student.sessionLinks.add(Session(
                                    link: linkController.text,
                                    dateTime: DateTime.now()));
                                widget.student.sessionCount--;
                              });
                            }
                          }
                        : null,
                    child: Text('ایجاد جلسه'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.student.sessionLinks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'جلسه ${index + 1} در تاریخ ${DateFormat('y/M/d').format(widget.student.sessionLinks[index].dateTime)} در ساعت ${DateFormat('H:m').format(widget.student.sessionLinks[index].dateTime)} ایجاد شد'),
                    subtitle: Text(
                        'لینک تکلیف آن جلسه ${widget.student.sessionLinks[index].link} است'),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: widget.student.payable - widget.student.paid > 0
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PaymentPage(student: widget.student)),
                      );
                    }
                  : null,
              icon: Icon(Icons.wallet),
              label: Text('پرداخت'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final Student student;

  PaymentPage({Key? key, required this.student}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final paidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحه پرداخت'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: paidController,
                decoration: InputDecoration(labelText: 'پرداخت شده'),
              ),
              ElevatedButton(
                onPressed: widget.student.payable - widget.student.paid > 0
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            widget.student.paid +=
                                int.parse(paidController.text);
                          });
                        }
                      }
                    : null,
                child: Text('پرداخت'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
