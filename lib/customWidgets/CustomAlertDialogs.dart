import 'package:flutter/material.dart';
import 'package:my_board_new/models/Lecture.dart';
import 'package:my_board_new/models/Resident.dart';
import 'package:my_board_new/services/services.dart';

showExcuseAbsenceFormDialog(BuildContext context, Map<String, dynamic> excuseAbsence, Lecture lecture, Resident resident) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textController = excuseAbsence != null ? TextEditingController(text: excuseAbsence['reason']) : TextEditingController();
  Services _services = Services();
  AlertDialog alert = AlertDialog(
    title: Text("Write excuse absence"),
    content: Form(
      key: _formKey,
      child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          controller: _textController,
          decoration: InputDecoration(
              labelText: 'Excuse absence',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 5.0),
              ))),
    ),
    actions: [
      ElevatedButton(onPressed: () {
        _services.removeExcusedAbsenceResident(lecture, resident, _textController.value.text);
        Navigator.pop(context);
      }, child: Text('Remove excuse')),
      ElevatedButton(onPressed: () {
        if(_formKey.currentState.validate()){
          _services.excusedAbsenceResident(lecture, resident, _textController.value.text);
          Navigator.pop(context);
        }
      }, child: Text('Send')),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
