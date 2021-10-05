import 'package:flutter/material.dart';
import 'package:my_board_new/customWidgets/CustomMessages.dart';
import 'package:my_board_new/models/Lecture.dart';
import 'package:my_board_new/services/services.dart';

class AddLecture extends StatefulWidget {
  final Function triggerUpdateLecturesFunc;
  AddLecture({this.triggerUpdateLecturesFunc});

  @override
  _AddLectureState createState() => _AddLectureState();
}

class _AddLectureState extends State<AddLecture> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _lecturerInputController = TextEditingController();
  TextEditingController _locationInputController = TextEditingController();
  TextEditingController _subjectInputController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime updatedSelectedDate = DateTime.now();
  Services _services = Services();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add lecture'),),
      body: Center(
        child: Container(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _lecturerInputController,
                    decoration: InputDecoration(
                        labelText: 'Lecturer name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 5.0),
                        ))),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _subjectInputController,
                    decoration: InputDecoration(
                        labelText: 'Lecture subject',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 5.0),
                        ))),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _locationInputController,
                    decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 5.0),
                        ))),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                    onTap: () async {
                      final DateTime picked =
                      await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2021, 9),
                          lastDate: DateTime(2035));
                      if (picked != null &&
                          picked != selectedDate)
                        setState(() {
                          print(picked);
                          selectedDate = picked;
                        });
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText:
                        '${selectedDate.year.toString()}/${selectedDate.month.toString()}/${selectedDate.day.toString()}',
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 5.0),
                        ))),
                SizedBox(
                  height: 12,
                ),
                Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState
                              .validate()) {
                            _services.addLecture(Lecture(
                                lecturer:
                                _lecturerInputController
                                    .value.text,
                                subject:
                                _subjectInputController
                                    .value.text,
                                location:
                                _locationInputController
                                    .value.text,
                                date: DateUtils.dateOnly(
                                    selectedDate),
                                residents: []));
                            Navigator.pop(context);
                            widget.triggerUpdateLecturesFunc();
                            showCustomSnackBar(context,
                                'Lecture added successfully');
                          }
                        },
                        icon: Icon(Icons.create),
                        label: Text('Add lecture'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
