import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_board_new/models/Lecture.dart';
import 'package:my_board_new/models/Resident.dart';

class Services {
  final CollectionReference _residentsCollection =
      FirebaseFirestore.instance.collection('residents');

  final CollectionReference _lecturesCollection =
      FirebaseFirestore.instance.collection('lectures');

  final CollectionReference _lecturersCollection =
      FirebaseFirestore.instance.collection('lecturers');

  Future addLecture(Lecture lecture) async {
    return await _lecturesCollection.doc().set(lecture.toMap());
  }

  // get lecture by uid
  Future<Lecture> getLecture(String lectureUid) async {
    return await _lecturesCollection
        .doc(lectureUid)
        .get()
        .then((document) => Lecture.fromFirebase(document.data(), document.id));
  }

  // get lecture by uid
  Future<List<Lecture>> getAllLectures() async {
    List<Lecture> lectures = await _lecturesCollection.get().then(
        (collection) => collection.docs
            .map((document) =>
                Lecture.fromFirebase(document.data(), document.id))
            .toList());

    lectures.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    return lectures;
  }

  // get today lecture
  Future<Lecture> getTodayLecture() async {
    DateTime dateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    QuerySnapshot<Map<String, dynamic>> query =
        await _lecturesCollection.where('date', isEqualTo: dateToday).get();
    //check if there is lecture or not
    if (query.size <= 0) {
      return null;
    }
    return Lecture.fromFirebase(query.docs.first.data(), query.docs.first.id);
  }

  Future<bool> attendResident(Lecture lecture, Resident resident) async {
    List<Map<String, dynamic>> lectureAttendees =
        await getLecture(lecture.id).then((value) => value.residents);
    if (lectureAttendees.contains(resident.id)) {
      return false;
    } else {
      String _now = DateFormat('hh:mm a').format(DateTime.now());
      lectureAttendees.add({'name': resident.name, 'time': '$_now'});
      return await _lecturesCollection
          .doc(lecture.id)
          .update({'residents': lectureAttendees}).then((value) => true);
    }
  }

  Future<bool> absentResident(Lecture lecture, Resident resident) async {
    List<Map<String, dynamic>> lectureAttendees =
        await getLecture(lecture.id).then((value) => value.residents);

    lectureAttendees.removeWhere((item) => item['name'] == resident.name);

    return await _lecturesCollection
        .doc(lecture.id)
        .update({'residents': lectureAttendees}).then((value) => true);
  }

  Future<bool> excusedAbsenceResident(
      Lecture lecture, Resident resident, String reason) async {
    List<Map<String, dynamic>> excusedAbsence = lecture.excusedAbsence;
    excusedAbsence.removeWhere((e) => e['name'] == resident.name);
    excusedAbsence.add({'name': resident.name, 'reason': reason});

    return await _lecturesCollection
        .doc(lecture.id)
        .update({'excusedAbsence': excusedAbsence}).then((value) => true);
  }

  Future<bool> removeExcusedAbsenceResident(
      Lecture lecture, Resident resident, String reason) async {
    List<Map<String, dynamic>> excusedAbsence = lecture.excusedAbsence;
    excusedAbsence.removeWhere((e) => e['name'] == resident.name);
    return await _lecturesCollection
        .doc(lecture.id)
        .update({'excusedAbsence': excusedAbsence}).then((value) => true);
  }

  Future addResident(Resident resident) async {
    return await _residentsCollection.doc().set(resident.toFirebaseMap());
  }

  Future<List<Resident>> getAllResidents() async {
    List<Resident> residents = await _residentsCollection.get().then(
        (collection) => collection.docs
            .map((document) =>
                Resident.fromFirebase(document.data(), document.id))
            .toList());

    residents.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });

    return residents;
  }

  Future<bool> editResident(Resident resident) async {
    return await _residentsCollection
        .doc(resident.id)
        .update(resident.toFirebaseMap())
        .then((value) => true);
  }

  Future<bool> editLecture(Lecture lecture) async {
    return await _lecturesCollection
        .doc(lecture.id)
        .update(lecture.toFirebaseMap())
        .then((value) => true);
  }

  Future<bool> deleteLecture(Lecture lecture) async {
    return await _lecturesCollection
        .doc(lecture.id)
        .delete()
        .then((value) => true);
  }
}
