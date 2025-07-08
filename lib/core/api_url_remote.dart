import 'package:shop_ease_admin/core/api_remote_base_url.dart';

class ApiUrlRemote {
  static const String bannerAdd = "${ApiRemoteBaseUrl.baseUrl}/banners/add";
  static const String bannerList = "${ApiRemoteBaseUrl.baseUrl}/banners";
  static String bannerById(String id) =>
      "${ApiRemoteBaseUrl.baseUrl}/banners/$id";
  static String bannerUpdate(String id) =>
      "${ApiRemoteBaseUrl.baseUrl}/banners/update/$id";
  static String bannerDelete(String id) =>
      "${ApiRemoteBaseUrl.baseUrl}/banners/delete/$id";

  static const String productAdd = "${ApiRemoteBaseUrl.baseUrl}/products/add";
  static const String productList = "${ApiRemoteBaseUrl.baseUrl}/products";
  static String productById(String id) =>
      "${ApiRemoteBaseUrl.baseUrl}/products/$id";
  static String productUpdate(String id) =>
      "${ApiRemoteBaseUrl.baseUrl}/products/update/$id";
  static String productDelete(String id) =>
      "${ApiRemoteBaseUrl.baseUrl}/products/delete/$id";
}
