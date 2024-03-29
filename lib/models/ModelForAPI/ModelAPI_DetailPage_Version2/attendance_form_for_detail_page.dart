class AttendanceFormDataForDetailPage {
  final String formID;
  final String startTime;
  final String endTime;
  final bool status;
  final String dateOpen;
  final int type;
  final double latitude;
  final double longitude;
  final double radius;

  AttendanceFormDataForDetailPage({
    required this.formID,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.dateOpen,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory AttendanceFormDataForDetailPage.fromJson(Map<String, dynamic> json) {

    return AttendanceFormDataForDetailPage(
      formID: json['formID'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      dateOpen: json['dateOpen'],
      type: json['type'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      radius: double.parse(json['radius'].toString()),
    );
  }
}