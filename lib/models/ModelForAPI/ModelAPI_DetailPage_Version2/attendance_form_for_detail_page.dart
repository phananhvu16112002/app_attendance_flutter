class AttendanceFormDataForDetailPage {
   String? formID;
   String? startTime;
   String? endTime;
   bool? status;
   String? dateOpen;
   int? type;
   double? latitude;
   double? longitude;
   double? radius;
   String? periodDateTime;

  AttendanceFormDataForDetailPage({
     this.formID,
     this.startTime,
     this.endTime,
     this.status,
     this.dateOpen,
     this.type,
     this.latitude,
     this.longitude,
     this.radius,
     this.periodDateTime
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
      periodDateTime: json['periodDateTime']
    );
  }
}