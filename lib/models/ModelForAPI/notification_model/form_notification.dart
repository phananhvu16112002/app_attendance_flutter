class FormNotification {
  String? formID;
  String? startTime;
  String? endTime;
  bool? status;
  String? dateOpen;
  int? type;
  double? latitude;
  double? longitude;
  double? radius;

  FormNotification({
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

  factory FormNotification.fromJson(Map<String, dynamic> json) =>
      FormNotification(
        formID: json["formID"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        status: json["status"],
        dateOpen: json["dateOpen"],
        type: json["type"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        radius: json["radius"],
      );

  Map<String, dynamic> toJson() => {
        "formID": formID,
        "startTime": startTime,
        "endTime": endTime,
        "status": status,
        "dateOpen": dateOpen,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "radius": radius,
      };
}
