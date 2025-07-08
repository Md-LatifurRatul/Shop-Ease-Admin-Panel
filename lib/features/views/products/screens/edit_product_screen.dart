import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_bloc.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_event.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_state.dart';
import 'package:shop_ease_admin/features/views/products/models/product_model.dart';
import 'package:shop_ease_admin/widgets/custom_image_card.dart';
import 'package:shop_ease_admin/widgets/custom_upload_button.dart';
import 'package:shop_ease_admin/widgets/image_selecting_button.dart';
import 'package:shop_ease_admin/widgets/snack_message.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  Uint8List? _selectUpdateImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _ratingController.text = widget.product.rating.toString();
    _descController.text = widget.product.description;
  }

  Future<void> _pickUpdateImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectUpdateImage = result.files.single.bytes;
      });
    }
  }

  void _uploadUpdateProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _ratingController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectUpdateImage == null) {
      SnackMessage.showSnackMessage(context, "Please fill all the fields");
      return;
    }

    final updatedProduct = ProductModel(
      id: widget.product.id,
      name: _nameController.text,
      price: double.tryParse(_ratingController.text) ?? 0,
      rating: double.tryParse(_ratingController.text) ?? 0,
      description: _descController.text,
      imageUrl: widget.product.imageUrl,
    );

    context.read<ProductBloc>().add(
      UpdateProductsEvent(
        product: updatedProduct,
        imageBytes: _selectUpdateImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) {
          SnackMessage.showSnackMessage(context, "Product updated!");

          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ProductBloc>().add(FetchProductsEvent());
          });
        } else if (state is ProductFailure) {
          SnackMessage.showSnackMessage(context, state.error);
          log(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Edit Product")),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildProductForm(state is ProductLoading)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductForm([bool isLoading = false]) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildTextField(_nameController, "Product Name")),
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
          CustomImageCard(
            imageBytes: _selectUpdateImage,
            imageUrl:
                _selectUpdateImage == null ? widget.product.imageUrl : null,
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              ImageSelectingButton(
                label: "Pick Update Product Image",
                onPressed: _pickUpdateImage,
              ),

              const SizedBox(width: 20),
            ],
          ),

          const SizedBox(height: 24),

          CustomUploadButton(
            label: isLoading ? "Updating..." : "Update Product",
            onPressed: isLoading ? null : _uploadUpdateProduct,
          ),
        ],
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
