// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Semester {
  int? semesterID;
  String? semesterName;
  String? semesterDescription;
  String? startDate;
  String? endDate;
  Semester({
    this.semesterID,
    this.semesterName,
    this.semesterDescription,
    this.startDate,
    this.endDate,
  });

  Semester copyWith({
    int? semesterID,
    String? semesterName,
    String? semesterDescription,
    String? startDate,
    String? endDate,
  }) {
    return Semester(
      semesterID: semesterID ?? this.semesterID,
      semesterName: semesterName ?? this.semesterName,
      semesterDescription: semesterDescription ?? this.semesterDescription,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'semesterID': semesterID,
      'semesterName': semesterName,
      'semesterDescription': semesterDescription,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Semester.fromJson(Map<String, dynamic> map) {
    return Semester(
      semesterID: map['semesterID'] != null ? map['semesterID'] as int : null,
      semesterName:
          map['semesterName'] != null ? map['semesterName'] as String : null,
      semesterDescription: map['semesterDescription'] != null
          ? map['semesterDescription'] as String
          : null,
      startDate: map['startDate'] != null ? map['startDate'] as String : null,
      endDate: map['endDate'] != null ? map['endDate'] as String : null,
    );
  }

  @override
  String toString() {
    return 'Semester(semesterID: $semesterID, semesterName: $semesterName, semesterDescription: $semesterDescription, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant Semester other) {
    if (identical(this, other)) return true;

    return other.semesterID == semesterID &&
        other.semesterName == semesterName &&
        other.semesterDescription == semesterDescription &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return semesterID.hashCode ^
        semesterName.hashCode ^
        semesterDescription.hashCode ^
        startDate.hashCode ^
        endDate.hashCode;
  }
}
