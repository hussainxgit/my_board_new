import 'package:flutter/material.dart';
import 'package:my_board_new/customWidgets/CustomMessages.dart';
import 'package:my_board_new/models/Resident.dart';
import 'package:my_board_new/services/services.dart';

class AddResident extends StatefulWidget {
  final Function triggerUpdateResidentsFunc;
  AddResident({this.triggerUpdateResidentsFunc});

  @override
  _AddResidentState createState() => _AddResidentState();
}

class _AddResidentState extends State<AddResident> {
  Services _services = Services();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _phoneInputController = TextEditingController();
  TextEditingController _fileNumberInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add resident'),
      ),
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
                    controller: _nameInputController,
                    decoration: InputDecoration(
                        labelText: 'Name',
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
                    controller: _phoneInputController,
                    decoration: InputDecoration(
                        labelText: 'Phone',
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
                    controller: _fileNumberInputController,
                    decoration: InputDecoration(
                        labelText: 'File number',
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
                          if (_formKey.currentState.validate()) {
                            _services.addResident(Resident(
                              name: _nameInputController.value.text,
                              phone: _phoneInputController.value.text,
                              fileNumber: _fileNumberInputController.value.text,
                            ));
                            Navigator.pop(context);
                            widget.triggerUpdateResidentsFunc();
                            showCustomSnackBar(
                                context, 'Resident added successfully');
                          }
                        },
                        icon: Icon(Icons.create),
                        label: Text('Add resident'))),
                SizedBox(
                  height: 32,
                ),
                InkWell(
                  child: Text('Back'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
