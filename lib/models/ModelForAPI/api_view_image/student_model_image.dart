class StudentModelImage{
  final int? imageID;
  final String? imageHash;
  final String? imageURL;

  StudentModelImage({this.imageID = 0, this.imageHash ='', this.imageURL =''});

  factory StudentModelImage.fromJson(Map<String, dynamic> json) {
    return StudentModelImage(
      imageID: json['imageID'],
      imageHash: json['imageHash'],
      imageURL: json['imageURL'],
    );
  }
}