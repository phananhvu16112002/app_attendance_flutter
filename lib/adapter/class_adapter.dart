import 'package:attendance_system_nodejs/models/course.dart';
import 'package:attendance_system_nodejs/models/teacher.dart';
import 'package:hive/hive.dart';
import 'package:attendance_system_nodejs/models/class.dart'; // Import Class class

class ClassAdapter extends TypeAdapter<Classes> {
  @override
  final int typeId = 0;

  @override
  Classes read(BinaryReader reader) {
    return Classes(
        classID: reader.readString(),
        roomNumber: reader.readString(),
        shiftNumber: reader.readInt(),
        startTime: reader.readString(),
        endTime: reader.readString(),
        classType: reader.readString(),
        group: reader.readString(),
        subGroup: reader.readString(),
        teacher: reader.read(),
        course: reader.read());
  }

  @override
  void write(BinaryWriter writer, Classes obj) {
    writer.writeString(obj.classID);
    writer.writeString(obj.roomNumber);
    writer.writeInt(obj.shiftNumber);
    writer.writeString(obj.startTime);
    writer.writeString(obj.endTime);
    writer.writeString(obj.classType);
    writer.writeString(obj.group);
    writer.writeString(obj.subGroup);
    writer.write(obj.teacher);
    writer.write(obj.course);
  }
}
