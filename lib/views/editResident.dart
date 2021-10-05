import 'package:flutter/material.dart';
import 'package:my_board_new/customWidgets/CustomMessages.dart';
import 'package:my_board_new/models/Resident.dart';
import 'package:my_board_new/services/services.dart';

class EditResident extends StatefulWidget {
  final Resident resident;
  final Function triggerUpdateResidentsFunc;

  EditResident({@required this.resident, this.triggerUpdateResidentsFunc});

  @override
  _EditResidentState createState() => _EditResidentState();
}

class _EditResidentState extends State<EditResident> {
  Services _services = Services();
  final _editFormKey = GlobalKey<FormState>();
  TextEditingController _editNameInputController;
  TextEditingController _editPhoneInputController;
  TextEditingController _editFileNumberInputController;
  Resident updatedResident;

  @override
  void initState() {
    super.initState();
    _editNameInputController =
        TextEditingController(text: widget.resident.name);
    _editPhoneInputController =
        TextEditingController(text: widget.resident.phone);
    _editFileNumberInputController =
        TextEditingController(text: widget.resident.fileNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit resident'),),
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
                    controller: _editNameInputController,
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
                    controller: _editPhoneInputController,
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
                    controller: _editFileNumberInputController,
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
                          if (_editFormKey.currentState.validate()) {
                            setState(() {});
                            updatedResident = Resident(
                              id: widget.resident.id,
                              name: _editNameInputController.value.text,
                              phone: _editPhoneInputController.value.text,
                              fileNumber:
                              _editFileNumberInputController.value.text,
                            );
                            _services.editResident(updatedResident);
                            Navigator.pop(context);
                            widget.triggerUpdateResidentsFunc();
                            showCustomSnackBar(
                                context, 'Resident edited successfully');
                          }
                        },
                        icon: Icon(Icons.create),
                        label: Text('Edit resident'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
