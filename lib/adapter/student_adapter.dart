import 'package:attendance_system_nodejs/models/student.dart';
import 'package:hive/hive.dart';

class StudentAdapter extends TypeAdapter<Student> {
  @override
  // TODO: implement typeId
  final int typeId = 4;

  @override
  Student read(BinaryReader reader) {
    return Student(
        studentID: reader.readString(),
        studentName: reader.readString(),
        studentEmail: reader.readString(),
        password: reader.readString(),
        hashedOTP: reader.readString(),
        accessToken: reader.readString(),
        refreshToken: reader.readString(),
        active: reader.readBool(),
        latitude: reader.readDouble(),
        longtitude: reader.readDouble(),
        location: reader.readString());
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer.writeString(obj.studentID);
    writer.writeString(obj.studentName);
    writer.writeString(obj.studentEmail);
    writer.writeString(obj.password);
    writer.writeString(obj.hashedOTP);
    writer.writeString(obj.accessToken);
    writer.writeString(obj.refreshToken);
    writer.writeBool(obj.active);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longtitude);
    writer.writeString(obj.location);
  }
}
