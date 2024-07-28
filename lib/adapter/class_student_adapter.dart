import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:hive/hive.dart';

class ClassesStudentAdapter extends TypeAdapter<ClassesStudent> {
  @override
  final int typeId = 7;

  @override
  ClassesStudent read(BinaryReader reader) {
    // TODO: implement read
    return ClassesStudent(
        studentID: reader.readString(),
        classID: reader.readString(),
        total: reader.readInt(),
        totalPresence: reader.readInt(),
        totalAbsence: reader.readInt(),
        totalLate: reader.readInt(),
        roomNumber: reader.readString(),
        shiftNumber: reader.readInt(),
        startTime: reader.readString(),
        endTime: reader.readString(),
        classType: reader.readString(),
        group: reader.readString(),
        subGroup: reader.readString(),
        courseID: reader.readString(),
        teacherID: reader.readString(),
        courseName: reader.readString(),
        totalWeeks: reader.readInt(),
        requiredWeeks: reader.readDouble(),
        credit: reader.readInt(),
        teacherEmail: reader.readString(),
        teacherName: reader.readString(),
        progress: reader.readDouble());
  }

  @override
  void write(BinaryWriter writer, ClassesStudent obj) {
    // TODO: implement write
    writer.writeString(obj.studentID);
    writer.writeString(obj.classID);
    writer.writeInt(obj.total);
    writer.writeInt(obj.totalPresence);
    writer.writeInt(obj.totalAbsence);
    writer.writeInt(obj.totalLate);
    writer.writeString(obj.roomNumber);
    writer.writeInt(obj.shiftNumber);
    writer.writeString(obj.startTime);
    writer.writeString(obj.endTime);
    writer.writeString(obj.classType);
    writer.writeString(obj.group);
    writer.writeString(obj.subGroup);
    writer.writeString(obj.courseID);
    writer.writeString(obj.teacherID);
    writer.writeString(obj.courseName);
    writer.writeInt(obj.totalWeeks);
    writer.writeDouble(obj.requiredWeeks);
    writer.writeInt(obj.credit);
    writer.writeString(obj.teacherEmail);
    writer.writeString(obj.teacherName);
    writer.writeDouble(obj.progress);
  }
}
