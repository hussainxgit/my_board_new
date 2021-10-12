import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_board_new/customWidgets/CustomAlertDialogs.dart';
import 'package:my_board_new/customWidgets/CustomMessages.dart';
import 'package:my_board_new/models/Lecture.dart';
import 'package:my_board_new/models/Resident.dart';
import 'package:my_board_new/services/services.dart';
import 'package:my_board_new/services/utilities.dart';

class LectureView2 extends StatefulWidget {
  final Lecture lecture;

  @override
  _LectureView2State createState() => _LectureView2State(lecture: this.lecture);

  LectureView2({@required this.lecture});
}

class _LectureView2State extends State<LectureView2> {
  Lecture lecture;

  _LectureView2State({@required this.lecture});

  Services _services = Services();
  Utilities _utilities = Utilities();
  List<Resident> residents = [];
  List<String> iconShuffle = [
    'graphics/emoji_gif_100px/emoji_28.gif',
    'graphics/emoji_gif_100px/emoji_25.gif',
    'graphics/emoji_gif_100px/emoji_23.gif',
    'graphics/emoji_gif_100px/emoji_11.gif',
    'graphics/emoji_gif_100px/emoji_3.gif',
    'graphics/emoji_gif_100px/emoji_18.gif',
    'graphics/emoji_gif_100px/emoji_10.gif',
  ];
  List<String> selectedResidentListIcon = [];
  List<String> excusedAbsenceResidentListIcon = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lecture.lecturer)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${lecture.date.year.toString()}/${lecture.date.month.toString()}/${lecture.date.day.toString()}',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          lecture.location,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      (lecture.residents.length == null ||
                              lecture.residents.isEmpty
                          ? '0'
                          : lecture.residents.length.toString()),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    lecture.lecturer,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Center(
                  child: Text(lecture.subject),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<List<Resident>>(
                future: _services.getAllResidents(),
                builder:
                    (context, AsyncSnapshot<List<Resident>> residentsList) {
                  List<Widget> children;
                  List<bool> selectedResidentList = [];
                  residents.clear();
                  if (residentsList.hasData) {
                    residentsList.data.forEach((element) {
                      if (lecture.getAttendedByName(element.name) != null) {
                        selectedResidentList.add(true);
                      } else {
                        selectedResidentList.add(false);
                      }
                    });
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: residentsList.data.length,
                      itemBuilder: (context, index) {
                        selectedResidentListIcon
                            .add((iconShuffle..shuffle()).first);
                        return ListTile(
                          selected: selectedResidentList[index],
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child:
                                          Text(residentsList.data[index].name)),
                                  selectedResidentList[index] == false
                                      ? IconButton(
                                          icon: lecture.getExcusedAbsenceByName(
                                                      residentsList
                                                          .data[index].name) !=
                                                  null
                                              ? Icon(
                                                  Icons.sd_card_alert_outlined)
                                              : Icon(Icons.done),
                                          onPressed: () {
                                            _services
                                                .attendResident(lecture,
                                                    residentsList.data[index])
                                                .then((value) {
                                              if (value == true) {
                                                setState(() {
                                                  selectedResidentList[index] =
                                                      true;
                                                });
                                              }
                                            });
                                          })
                                      : SizedBox(),
                                  selectedResidentList[index] == true
                                      ? InkWell(
                                          onTap: () {
                                            _services
                                                .absentResident(lecture,
                                                    residentsList.data[index])
                                                .then((value) {
                                              if (value == true) {
                                                setState(() {
                                                  selectedResidentList[index] =
                                                      false;
                                                });
                                              }
                                            });
                                          },
                                          child: Image.asset(
                                              selectedResidentListIcon[index],
                                              width: 50),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              Text(lecture.getAttendedByName(
                                          residentsList.data[index].name) !=
                                      null
                                  ? lecture.getAttendedByName(residentsList
                                              .data[index].name)['time'] !=
                                          null
                                      ? lecture.getAttendedByName(residentsList
                                          .data[index].name)['time']
                                      : ''
                                  : '')
                            ],
                          ),
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
                                          title: Text(
                                              residentsList.data[index].name)),
                                      Divider(),
                                      ListTile(
                                        title: new Text('Excused absence'),
                                        onTap: () {
                                          showExcuseAbsenceFormDialog(
                                              context,
                                              lecture.getExcusedAbsenceByName(
                                                  residentsList
                                                      .data[index].name),
                                              lecture,
                                              residentsList.data[index]);
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  );
                                });
                          },
                        );
                      },
                    );
                  } else if (residentsList.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${residentsList.error}'),
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
      ),
      floatingActionButton: ElevatedButton.icon(
          icon: Icon(Icons.download),
          onPressed: () async {
            if (this.lecture != null) {
              if (this.residents.isNotEmpty) {
                _utilities.setExcelLectureAttendees(
                    this.lecture, this.residents);
                showCustomSnackBar(
                    context, 'Excel file created in downloads directory');
              } else {
                _utilities.setExcelLectureAttendees(
                    this.lecture, this.residents);
                showCustomSnackBar(context,
                    'Excel file created in downloads directory, with 0 attendees');
              }
            } else {
              showCustomSnackBar(context, 'Error, No lecture found today');
            }
          },
          label: Text('Download as Excel')),
    );
  }
}
