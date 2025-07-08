import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model_local.dart';

abstract class BannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddBannerEvent extends BannerEvent {
  final BannerModelLocal banner;
  AddBannerEvent({required this.banner});

  @override
  List<Object?> get props => [banner];
}

class FetchBannersEvent extends BannerEvent {}

class UpdateBannerEvent extends BannerEvent {
  final String id;
  final String title;
  final Uint8List? imageBytes;

  UpdateBannerEvent({
    required this.id,
    required this.title,
    required this.imageBytes,
  });

  @override
  List<Object?> get props => [id, title, imageBytes];
}

class DeleteBannerEvent extends BannerEvent {
  final String id;
  DeleteBannerEvent(this.id);

  @override
  List<Object?> get props => [id];
}
