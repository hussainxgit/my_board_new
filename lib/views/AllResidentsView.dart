import 'package:flutter/material.dart';
import 'package:my_board_new/models/Resident.dart';
import 'package:my_board_new/services/services.dart';
import 'package:my_board_new/views/addResident.dart';
import 'package:flutter/cupertino.dart';

import 'editResident.dart';

class ResidentsView extends StatefulWidget {
  @override
  _ResidentsViewState createState() => _ResidentsViewState();
}

class _ResidentsViewState extends State<ResidentsView> {
  Services _services = Services();

  Future<List<Resident>> residents;

  @override
  void initState() {
    super.initState();
    residents = _services.getAllResidents();
  }

  void updateResidentsList() {
    setState(() {
      residents = _services.getAllResidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            FutureBuilder<List<Resident>>(
                future: residents,
                builder: (context, AsyncSnapshot<List<Resident>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditResident(
                                          resident: snapshot.data[index],
                                          triggerUpdateResidentsFunc:
                                              updateResidentsList,
                                        )));
                          },
                          onLongPress: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 5,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            height: 5,
                                            width: 50),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ListTile(
                                        title:
                                            new Text(snapshot.data[index].name),
                                      ),
                                      Divider(),
                                      ListTile(
                                        title: new Text('Delete'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  );
                                });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(snapshot.data[index].name)),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  );
                }),
            SizedBox(
              height: 60,
            ),
          ],
        ),
        floatingActionButton: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddResident(
                          triggerUpdateResidentsFunc: updateResidentsList)));
            },
            icon: Icon(Icons.edit),
            label: Text('Add resident')));
  }
}
