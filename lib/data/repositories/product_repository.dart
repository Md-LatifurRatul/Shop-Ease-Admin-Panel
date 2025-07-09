import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:shop_ease_admin/core/api_url_remote.dart';
import 'package:shop_ease_admin/features/views/products/models/product_model.dart';
import 'package:shop_ease_admin/services/network_service_banner.dart';

class ProductRepository {
  final NetworkService _networkService = NetworkService();

  Future<ProductModel> addProduct({
    required ProductModel product,
    required Uint8List imageBytes,
  }) async {
    final file = MultipartFile.fromBytes(
      "image",
      imageBytes,
      filename: "product.jpg",
    );

    final response = await _networkService.postMultipart(
      url: ApiUrlRemote.productAdd,
      fields: product.toMultipartFields(),
      files: [file],
    );

    if (response.statusCode == 201) {
      final respString = await response.stream.bytesToString();
      final json = jsonDecode(respString);
      return ProductModel.fromJson(json["product"]);
    } else {
      final respString = await response.stream.bytesToString();
      throw Exception("Failed to add product: $respString");
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await get(Uri.parse(ApiUrlRemote.productList));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch products");
    }
  }

  Future<ProductModel> fetchProductById(String id) async {
    final response = await get(Uri.parse(ApiUrlRemote.productById(id)));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProductModel.fromJson(json);
    } else {
      throw Exception("Failed to fetch product");
    }
  }

  Future<ProductModel> updateProduct({
    required ProductModel product,
    Uint8List? imageBytes,
  }) async {
    final fields = product.toMultipartFields();
    final files = <MultipartFile>[];
    if (imageBytes != null) {
      files.add(
        MultipartFile.fromBytes("image", imageBytes, filename: "product.jpg"),
      );
    }
    final response = await _networkService.putMultipart(
      url: ApiUrlRemote.productUpdate(product.id),
      fields: fields,
      files: files,
    );

    if (response.statusCode == 200) {
      final respString = await response.stream.bytesToString();
      final json = jsonDecode(respString);
      return ProductModel.fromJson(json["product"]);
    } else {
      final respString = await response.stream.bytesToString();
      throw Exception("Failed to update product: $respString");
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await delete(Uri.parse(ApiUrlRemote.productDelete(id)));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete product");
    }
  }

  Future<bool> doesProductTitleExist(String name) async {
    final response = await get(Uri.parse(ApiUrlRemote.productList));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.any((json) => json["name"] == name);
    } else {
      throw Exception("Failed to fetch products for title check");
    }
  }
}
