import 'package:flutter/material.dart';
import 'package:my_board_new/models/Lecture.dart';
import 'package:my_board_new/services/services.dart';
import 'package:my_board_new/views/editLecture.dart';
import 'package:my_board_new/views/lectureView2.dart';
import 'addLecture.dart';

class AllLecturesView extends StatefulWidget {
  @override
  _AllLecturesViewState createState() => _AllLecturesViewState();
}

class _AllLecturesViewState extends State<AllLecturesView> {
  Services _services = Services();
  Future<List<Lecture>> lectures;

  @override
  void initState() {
    super.initState();
    lectures = _services.getAllLectures();
  }

  void updateLecturesList() {
    setState(() {
      lectures = _services.getAllLectures();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            FutureBuilder<List<Lecture>>(
                future: lectures,
                builder: (context, AsyncSnapshot<List<Lecture>> snapshot) {
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
                                    builder: (_) => LectureView2(
                                          lecture: snapshot.data[index],
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
                                        title: new Text(
                                            '${snapshot.data[index].date.year.toString()}/${snapshot.data[index].date.month.toString()}/${snapshot.data[index].date.day.toString()} - ${snapshot.data[index].lecturer}'),
                                      ),
                                      Divider(),
                                      ListTile(
                                        title: new Text('Edit'),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => EditLecture(
                                                        lecture: snapshot
                                                            .data[index],
                                                        triggerUpdateLecturesFunc:
                                                            updateLecturesList,
                                                      )));
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ListTile(
                                        title: new Text('Delete'),
                                        onTap: () {
                                          _services
                                              .deleteLecture(
                                                  snapshot.data[index])
                                              .then((value) {
                                            updateLecturesList();
                                            Navigator.pop(context);
                                          });
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
                              Expanded(
                                  child: Text(
                                      '${snapshot.data[index].date.year.toString()}/${snapshot.data[index].date.month.toString()}/${snapshot.data[index].date.day.toString()} - ${snapshot.data[index].lecturer}')),
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
                      builder: (_) => AddLecture(
                            triggerUpdateLecturesFunc: updateLecturesList,
                          )));
            },
            icon: Icon(Icons.edit),
            label: Text('Add lecture')));
  }
}
