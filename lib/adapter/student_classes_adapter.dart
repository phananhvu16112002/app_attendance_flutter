import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:hive/hive.dart';

class StudentClassesAdapter extends TypeAdapter<StudentClasses> {
  @override
  final int typeId = 3;

  @override
  StudentClasses read(BinaryReader reader) {
    return StudentClasses(
        studentID: reader.read(),
        classes: reader.read(),
        progress: reader.readDouble(),
        total: reader.readDouble(),
        totalPresence: reader.readInt(),
        totalAbsence: reader.readInt(),
        totalLate: reader.readInt());
  }

  @override
  void write(BinaryWriter writer, StudentClasses obj) {
    writer.write(obj.studentID);
    writer.write(obj.classes);
    writer.writeDouble(obj.progress);
    writer.writeDouble(obj.total);
    writer.writeInt(obj.totalPresence);
    writer.writeInt(obj.totalAbsence);
    writer.writeInt(obj.totalLate);
  }
}
