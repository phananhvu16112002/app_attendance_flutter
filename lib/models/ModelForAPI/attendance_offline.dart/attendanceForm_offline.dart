class AttendanceFormOffline {
  String? formID;
  String? startTime;
  String? endTime;
  bool? status;
  String? dateOpen;
  int? type;
  double? latitude;
  double? longitude;
  double? radius;

  AttendanceFormOffline({
    this.formID,
    this.startTime,
    this.endTime,
    this.status,
    this.dateOpen,
    this.type,
    this.latitude,
    this.longitude,
    this.radius,
  });

  factory AttendanceFormOffline.fromJson(Map<String, dynamic> json) {
    return AttendanceFormOffline(
      formID: json['formID'],
      startTime: (json['startTime']),
      endTime: (json['endTime']),
      status: json['status'],
      dateOpen: (json['dateOpen']),
      type: json['type'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      radius: double.parse(json['radius'].toString()),
    );
  }
}
