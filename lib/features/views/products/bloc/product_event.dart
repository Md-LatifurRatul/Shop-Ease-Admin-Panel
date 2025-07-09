import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:shop_ease_admin/features/views/products/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProductEvent extends ProductEvent {
  final ProductModel product;
  final Uint8List imageBytes;

  AddProductEvent({required this.product, required this.imageBytes});
}

class FetchProductsEvent extends ProductEvent {}

class UpdateProductsEvent extends ProductEvent {
  final ProductModel product;
  final Uint8List? imageBytes;

  UpdateProductsEvent({required this.product, this.imageBytes});
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  DeleteProductEvent({required this.id});
}

class CheckProductNameEvent extends ProductEvent {
  final String name;
  CheckProductNameEvent({required this.name});
}
