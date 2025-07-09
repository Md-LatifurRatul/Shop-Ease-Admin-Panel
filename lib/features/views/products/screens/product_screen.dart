import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/cubit/image_picker_cubit.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_bloc.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_event.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_state.dart';
import 'package:shop_ease_admin/features/views/products/models/product_model.dart';
import 'package:shop_ease_admin/utils/image_picker_util.dart';
import 'package:shop_ease_admin/widgets/custom_image_card.dart';
import 'package:shop_ease_admin/widgets/custom_upload_button.dart';
import 'package:shop_ease_admin/widgets/header_widget.dart';
import 'package:shop_ease_admin/widgets/image_selecting_button.dart';
import 'package:shop_ease_admin/widgets/snack_message.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _pickImage() async {
    final bytes = await pickImage();
    if (bytes != null) {
      context.read<ImagePickerCubit>().setImage(bytes);
    }
  }

  void _uploadProduct(Uint8List? imageBytes) async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _ratingController.text.isEmpty ||
        _descController.text.isEmpty ||
        imageBytes == null) {
      SnackMessage.showSnackMessage(context, "Please fill all the fields");
      return;
    }

    final product = ProductModel(
      id: "",
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      rating: double.tryParse(_ratingController.text) ?? 0,
      description: _descController.text,
      imageUrl: "",
    );

    context.read<ProductBloc>().add(
      AddProductEvent(product: product, imageBytes: imageBytes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) {
          SnackMessage.showSnackMessage(context, "Product uploaded!");

          _nameController.clear();
          _priceController.clear();
          _ratingController.clear();
          _descController.clear();
          context.read<ImagePickerCubit>().clearImage();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ProductBloc>().add(FetchProductsEvent());
          });
        } else if (state is ProductFailure) {
          SnackMessage.showSnackMessage(context, state.error);
          log(state.error);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderWidget(title: "Manage Products"),
            _buildProductForm(state is ProductLoading),
          ],
        );
      },
    );
  }

  Widget _buildProductForm([bool isLoading = false]) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<ImagePickerCubit, Uint8List?>(
        builder: (context, imageBytes) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_nameController, "Product Name"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      _priceController,
                      "Price",
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      _ratingController,
                      "Rating",
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildTextField(_descController, "Description", maxLines: 3),

              const SizedBox(height: 16),
              CustomImageCard(imageBytes: imageBytes),
              const SizedBox(height: 10),

              Row(
                children: [
                  ImageSelectingButton(
                    label: "Pick Product Image",
                    onPressed: _pickImage,
                  ),

                  const SizedBox(width: 20),
                ],
              ),

              const SizedBox(height: 24),

              CustomUploadButton(
                label: isLoading ? "Uploading..." : "Upload Product",
                onPressed: isLoading ? null : () => _uploadProduct(imageBytes),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: inputType,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
