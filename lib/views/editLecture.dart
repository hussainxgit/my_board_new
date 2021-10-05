import 'package:flutter/material.dart';
import 'package:my_board_new/customWidgets/CustomMessages.dart';
import 'package:my_board_new/models/Lecture.dart';
import 'package:my_board_new/services/services.dart';

class EditLecture extends StatefulWidget {
  final Lecture lecture;
  final Function triggerUpdateLecturesFunc;

  EditLecture({@required this.lecture, this.triggerUpdateLecturesFunc});

  @override
  _EditLectureState createState() => _EditLectureState();
}

class _EditLectureState extends State<EditLecture> {
  final _editFormKey = GlobalKey<FormState>();
  Services _services = Services();
  TextEditingController _editLecturerInputController;
  TextEditingController _editSubjectInputController;
  TextEditingController _editLocationInputController;
  DateTime selectedDate;
  Lecture updatedLecture;

  Future<void> _selectDate(BuildContext context, DateTime dateTime) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2021, 9),
        lastDate: DateTime(2035));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    _editLecturerInputController =
        TextEditingController(text: widget.lecture.lecturer);
    _editSubjectInputController =
        TextEditingController(text: widget.lecture.subject);
    _editLocationInputController =
        TextEditingController(text: widget.lecture.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit lecture'),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Form(
            key: _editFormKey,
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
                    controller: _editLecturerInputController,
                    decoration: InputDecoration(
                        labelText: 'Lecturer',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
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
                    controller: _editSubjectInputController,
                    decoration: InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
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
                    controller: _editLocationInputController,
                    decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                        ))),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                    onTap: () => _selectDate(context, widget.lecture.date),
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: selectedDate == null
                            ? '${widget.lecture.date.year}/${widget.lecture.date.month}/${widget.lecture.date.day}'
                            : '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                        ))),
                SizedBox(
                  height: 12,
                ),
                Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (_editFormKey.currentState.validate()) {
                            updatedLecture = Lecture(
                                id: widget.lecture.id,
                                lecturer:
                                    _editLecturerInputController.value.text,
                                subject: _editSubjectInputController.value.text,
                                location:
                                    _editLocationInputController.value.text,
                                date: selectedDate != null
                                    ? selectedDate
                                    : widget.lecture.date);
                            _services.editLecture(updatedLecture);
                            Navigator.pop(context);
                            widget.triggerUpdateLecturesFunc();
                            showCustomSnackBar(
                                context, 'Lecture edited successfully');
                          }
                        },
                        icon: Icon(Icons.create),
                        label: Text('Edit lecture'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
