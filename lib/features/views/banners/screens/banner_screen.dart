import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/cubit/image_picker_cubit.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_bloc.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_event.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_state.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model_local.dart';
import 'package:shop_ease_admin/utils/image_picker_util.dart';
import 'package:shop_ease_admin/widgets/custom_image_card.dart';
import 'package:shop_ease_admin/widgets/custom_upload_button.dart';
import 'package:shop_ease_admin/widgets/image_selecting_button.dart';
import 'package:shop_ease_admin/widgets/side_bar_menu.dart';
import 'package:shop_ease_admin/widgets/snack_message.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  String currentRoute = "/banners";

  final TextEditingController _titleController = TextEditingController();

  Future<void> _pickBannerImage() async {
    final bytes = await pickImage();
    context.read<ImagePickerCubit>().setImage(bytes);
  }

  Future<void> _uploadBanner(Uint8List? imageBytes) async {
    if (_titleController.text.isEmpty || imageBytes == null) {
      SnackMessage.showSnackMessage(context, "Please fill all the fields");
      return;
    }

    // Backend

    final banner = BannerModelLocal(
      title: _titleController.text,
      imageBytes: imageBytes,
    );

    context.read<BannerBloc>().add(AddBannerEvent(banner: banner));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is BannerLocalSuccess) {
          SnackMessage.showSnackMessage(context, "Banner uploaded!");

          _titleController.clear();
          context.read<ImagePickerCubit>().clearImage();
        } else if (state is BannerFailure) {
          SnackMessage.showSnackMessage(context, state.error);
          log(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Row(
            children: [
              SideBarMenu(
                selectRoute: currentRoute,
                onMenuItemSelected: (route) {
                  setState(() {
                    currentRoute = route;
                  });
                  Navigator.pushNamed(context, route);
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _buildHeader(),

                    if (state is! BannerLoading) _buildBannerForm(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: Colors.deepPurple[50],
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Manage Banners",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBannerForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<ImagePickerCubit, Uint8List?>(
        builder: (context, imageBytes) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Banner Title"),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your banner title'
                            : null,

                onChanged: (_) {},
              ),
              const SizedBox(height: 20),

              CustomImageCard(imageBytes: imageBytes),
              const SizedBox(height: 20),

              ImageSelectingButton(
                label: "Choose Image",
                onPressed: _pickBannerImage,
              ),

              const SizedBox(height: 20),

              CustomUploadButton(
                label: "Upload Banner",
                onPressed: () {
                  _uploadBanner(imageBytes);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
