import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:shop_ease_admin/core/api_url_remote.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model_local.dart';
import 'package:shop_ease_admin/services/network_service_banner.dart';

class BannerRepository {
  final NetworkService _networkService = NetworkService();

  Future<BannerModelLocal> addBanner(BannerModelLocal banner) async {
    final file = MultipartFile.fromBytes(
      "image",
      banner.imageBytes!,
      filename: "banner.jpg",
    );

    final response = await _networkService.postMultipart(
      url: ApiUrlRemote.bannerAdd,
      fields: banner.toMultiPartFields(),
      files: [file],
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final respString = await response.stream.bytesToString();
      final json = jsonDecode(respString);
      return BannerModelLocal.fromJson(json['banner']);
    } else {
      final respString = await response.stream.bytesToString();
      throw Exception("Failed to add banner: $respString");
    }
  }

  Future<List<BannerModel>> fetchBanners() async {
    final response = await get(Uri.parse(ApiUrlRemote.bannerList));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch banners");
    }
  }

  Future<BannerModel> updateBanner({
    required String id,
    required String title,
    Uint8List? imageBytes,
  }) async {
    final fields = {"title": title};
    final files = <MultipartFile>[];
    if (imageBytes != null) {
      files.add(
        MultipartFile.fromBytes("image", imageBytes, filename: "banner.jpg"),
      );
    }
    final response = await _networkService.putMultipart(
      url: ApiUrlRemote.bannerUpdate(id),
      fields: fields,
      files: files,
    );

    if (response.statusCode == 200) {
      final respString = await response.stream.bytesToString();
      final json = jsonDecode(respString);
      return BannerModel.fromJson(json['banner']);
    } else {
      final respString = await response.stream.bytesToString();
      throw Exception('Failed to update banner: $respString');
    }
  }

  Future<void> deleteBanner(String id) async {
    final response = await delete(Uri.parse(ApiUrlRemote.bannerDelete(id)));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete banner");
    }
  }
}
