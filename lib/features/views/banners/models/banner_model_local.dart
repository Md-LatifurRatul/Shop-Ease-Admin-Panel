import 'dart:typed_data';

class BannerModelLocal {
  final String title;
  final Uint8List? imageBytes;

  BannerModelLocal({required this.title, this.imageBytes});

  Map<String, String> toMultiPartFields() {
    return {"title": title};
  }

  factory BannerModelLocal.fromJson(Map<String, dynamic> json) {
    return BannerModelLocal(title: json["title"]);
  }
}
