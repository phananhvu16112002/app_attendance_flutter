class ReportImage {
   String? imageID;
   dynamic? imageURL;

  ReportImage({required this.imageID, required this.imageURL});

  factory ReportImage.fromJson(Map<String, dynamic> json) {
    return ReportImage(imageID: json['imageID'] ?? '', imageURL: json['imageURL'] ?? '');
  }
}
