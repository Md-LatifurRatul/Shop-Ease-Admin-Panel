import 'package:equatable/equatable.dart';
import 'package:shop_ease_admin/features/views/products/models/product_model.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductIntial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> product;
  ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductSuccess extends ProductState {
  final ProductModel product;
  ProductSuccess(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductFailure extends ProductState {
  final String error;
  ProductFailure(this.error);

  @override
  List<Object?> get props => [error];
}
