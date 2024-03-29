import 'package:attendance_system_nodejs/models/Teacher.dart';
import 'package:hive/hive.dart';

class TeacherAdapter extends TypeAdapter<Teacher> {
  @override
  final int typeId = 1; // TypeId cho lớp Teacher

  @override
  Teacher read(BinaryReader reader) {
    return Teacher(
      teacherID: reader.readString(),
      teacherName: reader.readString(),
      teacherHashedPassword: reader.readString(),
      teacherEmail: reader.readString(),
      teacherHashedOTP: reader.readString(),
      timeToLiveOTP: reader.readString(),
      accessToken: reader.readString(),
      refreshToken: reader.readString(),
      resetToken: reader.readString(),
      active: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Teacher obj) {
    writer.writeString(obj.teacherID);
    writer.writeString(obj.teacherName);
    writer.writeString(obj.teacherHashedPassword);
    writer.writeString(obj.teacherEmail);
    writer.writeString(obj.teacherHashedOTP);
    writer.writeString(obj.timeToLiveOTP);
    writer.writeString(obj.accessToken);
    writer.writeString(obj.refreshToken);
    writer.writeString(obj.resetToken);
    writer.writeBool(obj.active);
  }
}
