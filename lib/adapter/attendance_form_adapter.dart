import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:hive/hive.dart';

class AttendanceFormAdapter extends TypeAdapter<AttendanceForm> {
  @override
  final int typeId = 5;

  @override
  AttendanceForm read(BinaryReader reader) {
    // TODO: implement read
    return AttendanceForm(
        formID: reader.readString(),
        classes: reader.readString(),
        startTime: reader.readString(),
        endTime: reader.readString(),
        dateOpen: reader.readString(),
        status: reader.readBool(),
        typeAttendance: reader.readInt(),
        location: reader.readString(),
        latitude: reader.readDouble(),
        longtitude: reader.readDouble(),
        radius: reader.readDouble());
  }

  @override
  void write(BinaryWriter writer, AttendanceForm obj) {
    writer.writeString(obj.formID);
    writer.writeString(obj.classes);
    writer.writeString(obj.startTime);
    writer.writeString(obj.endTime);
    writer.writeString(obj.dateOpen);
    writer.writeBool(obj.status);
    writer.writeInt(obj.typeAttendance);
    writer.writeString(obj.location);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longtitude);
    writer.writeDouble(obj.radius);
  }
}
