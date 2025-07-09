import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/cubit/image_picker_cubit.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_bloc.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_event.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_state.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model.dart';
import 'package:shop_ease_admin/utils/image_picker_util.dart';
import 'package:shop_ease_admin/widgets/custom_image_card.dart';
import 'package:shop_ease_admin/widgets/custom_upload_button.dart';
import 'package:shop_ease_admin/widgets/image_selecting_button.dart';
import 'package:shop_ease_admin/widgets/snack_message.dart';

class EditBannerScreen extends StatefulWidget {
  final BannerModel banner;

  const EditBannerScreen({super.key, required this.banner});

  @override
  State<EditBannerScreen> createState() => _EditBannerScreenState();
}

class _EditBannerScreenState extends State<EditBannerScreen> {
  TextEditingController _titleController = TextEditingController();
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.banner.title);
    _existingImageUrl = widget.banner.imageUrl;
  }

  Future<void> _pickUpdateBannerImage() async {
    final bytes = await pickImage();

    if (bytes != null) {
      context.read<ImagePickerCubit>().setImage(bytes);
    }
  }

  Future<void> _uploadUpdateBanner(Uint8List? imageBytes) async {
    if (_titleController.text.isEmpty || imageBytes == null) {
      SnackMessage.showSnackMessage(context, "Please update all the fields");
      return;
    }

    context.read<BannerBloc>().add(
      UpdateBannerEvent(
        id: widget.banner.id,
        title: _titleController.text,
        imageBytes: imageBytes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is BannerSuccess) {
          SnackMessage.showSnackMessage(context, "Banner updated!");
          context.read<ImagePickerCubit>().clearImage();
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<BannerBloc>().add(FetchBannersEvent());
          });
        } else if (state is BannerFailure) {
          SnackMessage.showSnackMessage(context, state.error);
          log(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Edit Banner")),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Banner Title"),
                ),
                const SizedBox(height: 20),
                BlocBuilder<ImagePickerCubit, Uint8List?>(
                  builder: (context, imageBytes) {
                    return CustomImageCard(
                      imageBytes: imageBytes,
                      imageUrl: imageBytes == null ? _existingImageUrl : null,
                    );
                  },
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 10),
                ImageSelectingButton(
                  label: "Change Image",
                  onPressed: _pickUpdateBannerImage,
                ),

                const SizedBox(height: 30),

                BlocBuilder<ImagePickerCubit, Uint8List?>(
                  builder: (context, imageBytes) {
                    return CustomUploadButton(
                      label:
                          state is BannerLoading
                              ? "Updating..."
                              : "Update Banner",
                      onPressed:
                          state is BannerLoading
                              ? null
                              : () => _uploadUpdateBanner(imageBytes),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
