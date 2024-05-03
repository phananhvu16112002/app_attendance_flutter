class ClassRoom {
  String? studentID;
  String? studentName;
  String? studentEmail;

  ClassRoom({
    this.studentID,
    this.studentName,
    this.studentEmail,
  });

  factory ClassRoom.fromJson(Map<String, dynamic> json) => ClassRoom(
        studentID: json['studentDetail']['studentID'],
        studentName: json['studentDetail']['studentName'],
        studentEmail: json['studentDetail']['studentEmail'],
      );
}
