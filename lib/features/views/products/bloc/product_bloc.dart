import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/data/repositories/product_repository.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_event.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductIntial()) {
    on<AddProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await repository.addProduct(
          product: event.product,
          imageBytes: event.imageBytes,
        );

        emit(ProductSuccess(product));
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    });
    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.fetchProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    });
    on<UpdateProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await repository.updateProduct(
          product: event.product,
          imageBytes: event.imageBytes,
        );

        emit(ProductSuccess(product));
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    });
    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await repository.deleteProduct(event.id);
        final products = await repository.fetchProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    });
  }
}
