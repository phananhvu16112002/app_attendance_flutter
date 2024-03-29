import 'package:attendance_system_nodejs/models/Course.dart';
import 'package:hive/hive.dart';
// Đổi tên import theo tên gói của bạn

class CourseAdapter extends TypeAdapter<Course> {
  @override
  final int typeId = 2; // TypeId cho lớp Course

  @override
  Course read(BinaryReader reader) {
    return Course(
      courseID: reader.readString(),
      courseName: reader.readString(),
      totalWeeks: reader.readInt(),
      requiredWeeks: reader.readInt(),
      credit: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Course obj) {
    writer.writeString(obj.courseID);
    writer.writeString(obj.courseName);
    writer.writeInt(obj.totalWeeks);
    writer.writeInt(obj.requiredWeeks);
    writer.writeInt(obj.credit);
  }
}
