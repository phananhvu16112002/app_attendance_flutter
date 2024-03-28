import 'package:attendance_system_nodejs/models/DataOffline.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class DataOfflineAdatper extends TypeAdapter<DataOffline> {
  @override
  // TODO: implement typeId
  final int typeId = 6;
  @override
  DataOffline read(BinaryReader reader) {
    return DataOffline(
        studentID: reader.readString(),
        classID: reader.readString(),
        formID: reader.readString(),
        dateAttendanced: reader.readString(),
        location: reader.readString(),
        latitude: reader.readDouble(),
        longitude: reader.readDouble());
  }

  @override
  void write(BinaryWriter writer, DataOffline obj) {
    writer.writeString(obj.studentID);
    writer.writeString(obj.classID);
    writer.writeString(obj.formID);
    writer.writeString(obj.dateAttendanced);
    writer.writeString(obj.location);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
  }
}
