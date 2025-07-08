import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_bloc.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_event.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_state.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model.dart';
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
  Uint8List? _imageBytes;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.banner.title);
    _existingImageUrl = widget.banner.imageUrl;
  }

  Future<void> _pickUpdateBannerImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _uploadUpdateBanner() async {
    if (_titleController.text.isEmpty || _imageBytes == null) {
      SnackMessage.showSnackMessage(context, "Please fill all the fields");
      return;
    }

    context.read<BannerBloc>().add(
      UpdateBannerEvent(
        id: widget.banner.id,
        title: _titleController.text,
        imageBytes: _imageBytes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is BannerSuccess) {
          SnackMessage.showSnackMessage(context, "Banner updated!");
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
                CustomImageCard(
                  imageBytes: _imageBytes,
                  imageUrl: _imageBytes == null ? _existingImageUrl : null,
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 10),
                ImageSelectingButton(
                  label: "Change Image",
                  onPressed: _pickUpdateBannerImage,
                ),

                const SizedBox(height: 30),

                CustomUploadButton(
                  label:
                      state is BannerLoading ? "Updating..." : "Update Banner",
                  onPressed:
                      state is BannerLoading ? null : _uploadUpdateBanner,
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
