class Lecturer {
  String id, name, phone, fileNumber;

  Lecturer({this.id, this.name, this.phone, this.fileNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'phone': this.phone,
      'fileNumber': this.fileNumber,
    };
  }

  factory Lecturer.fromMap(Map<String, dynamic> map) {
    return Lecturer(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      fileNumber: map['fileNumber'] as String,
    );
  }

  factory Lecturer.fromFirebaseMap(Map<String, dynamic> map, String uid) {
    return Lecturer(
      id: uid,
      name: map['name'] as String,
      phone: map['phone'] as String,
      fileNumber: map['fileNumber'] as String,
    );
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'name': this.name,
      'phone': this.phone,
      'fileNumber': this.fileNumber,
    };
  }
}
