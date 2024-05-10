import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

@HiveType(typeId: 6)
class DataOffline {
  @HiveField(0)
  String? studentID;
  @HiveField(1)
  String? formID;
  @HiveField(2)
  String? classID;
  @HiveField(3)
  String? dateAttendanced;
  @HiveField(4)
  String? location;
  @HiveField(5)
  double? latitude;
  @HiveField(6)
  double? longitude;
  @HiveField(7)
  String? startTime;
  @HiveField(8)
  String? endTime;


  DataOffline(
      { this.studentID = '',
       this.classID = '',
       this.formID = '',
       this.dateAttendanced = '',
       this.location = '',
       this.latitude = 0.0,
       this.longitude = 0.0,
       this.startTime = '',
       this.endTime =  '',

      });
}
