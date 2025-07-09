import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/config/app_router.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_bloc.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_event.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_state.dart';
import 'package:shop_ease_admin/widgets/confirm_alert.dart';
import 'package:shop_ease_admin/widgets/snack_message.dart';

class ProductListSection extends StatefulWidget {
  const ProductListSection({super.key});

  @override
  State<ProductListSection> createState() => _ProductListSectionState();
}

class _ProductListSectionState extends State<ProductListSection> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Products",
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        // Product List with fixed height
        SizedBox(
          height: 500,
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                final products = state.product;
                if (products.isEmpty) {
                  return const Center(child: Text("No products found."));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading:
                            product.imageUrl.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    product.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          color: Colors.grey.shade600,
                                        ),
                                  ),
                                )
                                : Icon(
                                  Icons.shopping_bag,
                                  color: Colors.grey.shade600,
                                ),
                        title: Text(product.name),
                        subtitle: Text(
                          "Price: \$${product.price} | Rating: ${product.rating}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.editProduct,
                                  arguments: product,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                ConfirmAlert.showConfirmAlertDialogue(
                                  context,
                                  title: "Delete Product",
                                  content: 'Are you sure you want to delete?',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.read<ProductBloc>().add(
                                      DeleteProductEvent(id: product.id),
                                    );
                                    SnackMessage.showSnackMessage(
                                      context,
                                      "Product deleted!",
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is ProductFailure) {
                return Center(child: Text("Error: ${state.error}"));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
