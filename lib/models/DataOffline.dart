import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

@HiveType(typeId: 6)
class DataOffline {
  @HiveField(0)
  String studentID;
  @HiveField(1)
  String formID;
  @HiveField(2)
  String classID;
  @HiveField(3)
  String dateAttendanced;
  @HiveField(4)
  String location;
  @HiveField(5)
  double latitude;
  @HiveField(6)
  double longitude;


  DataOffline(
      {required this.studentID,
      required this.classID,
      required this.formID,
      required this.dateAttendanced,
      required this.location,
      required this.latitude,
      required this.longitude,
      });
}
