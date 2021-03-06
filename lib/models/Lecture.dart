import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_board_new/models/Resident.dart';

class Lecture {
  String id, location, lecturer, subject;
  DateTime date;
  List<Map<String, dynamic>> residents = [];
  List<Resident> getAttendedR = [];
  List<Map<String, dynamic>> excusedAbsence = [];

  Lecture({
    this.id,
    this.date,
    this.location,
    this.lecturer,
    this.subject,
    this.residents,
    this.excusedAbsence,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'id': this.id,
      'date': this.date,
      'location': this.location,
      'lecturer': this.lecturer,
      'subject': this.subject,
      'excusedAbsence': this.excusedAbsence,
    };
    if (this.residents != null || this.residents.isNotEmpty) {
      data.addAll({
        'residents': this.residents.map<Map<String, dynamic>>((e) => e).toList(),
      });
    } else {
      data.addAll({'residents': []});
    }
    return data;
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    Timestamp timestampDate = map['date'] as Timestamp;
    return Lecture(
      id: map['id'] as String,
      location: map['location'] as String,
      lecturer: map['lecturer'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(timestampDate.seconds * 1000),
      subject: map['subject'] as String,
      residents: map['residents'].cast<String>(),
    );
  }

  factory Lecture.fromFirebase(Map<String, dynamic> map, String uid) {
    Timestamp timestampDate = map['date'] as Timestamp;
    return Lecture(
      id: uid,
      location: map['location'] as String,
      lecturer: map['lecturer'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(timestampDate.seconds * 1000),
      subject: map['subject'] as String,
      residents: map['residents'] != null ? (map['residents'] as List<dynamic>).map<Map<String, dynamic>>((item) => item).toList() : [],
      excusedAbsence: map['excusedAbsence'] != null ? (map['excusedAbsence'] as List<dynamic>).map<Map<String, dynamic>>((item) => item).toList() : [],
    );
  }

  Map<String, dynamic> toFirebaseMap() {
    Map<String, dynamic> data = {
      'date': this.date,
      'location': this.location,
      'lecturer': this.lecturer,
      'subject': this.subject,
    };
    if (this.residents != null) {
      data.addAll({
        'residents': this.residents.map<Map<String, dynamic>>((e) => e).toList(),
      });
    } else {
      data.addAll({'residents': []});
    }

    if (this.excusedAbsence != null) {
      data.addAll({
        'excusedAbsence': this.excusedAbsence,
      });
    } else {
      data.addAll({'excusedAbsence': []});
    }
    return data;
  }

  List<Resident> getAttendedResidents(List<Resident> givenResident) {
    getAttendedR.clear();
    givenResident.forEach((resident) {
      if (residents.contains(resident.name)) {
        getAttendedR.add(resident);
      }
    });
    return getAttendedR;
  }

  Map<String, dynamic> getExcusedAbsenceByName(String name){
    return excusedAbsence.firstWhere((o) => o['name'] == name , orElse: () => null);

  }

  Map<String, dynamic> getAttendedByName(String name){
    return residents.firstWhere((o) => o['name'] == name , orElse: () => null);

  }


}
