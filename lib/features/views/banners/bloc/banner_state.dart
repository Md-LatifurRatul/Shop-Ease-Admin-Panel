import 'package:equatable/equatable.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model_local.dart';

abstract class BannerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLocalSuccess extends BannerState {
  final BannerModelLocal banner;
  BannerLocalSuccess(this.banner);

  @override
  List<Object?> get props => [banner];
}

class BannerSuccess extends BannerState {
  final BannerModel banner;
  BannerSuccess(this.banner);

  @override
  List<Object?> get props => [banner];
}

class BannerFailure extends BannerState {
  final String error;
  BannerFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class BannerLoaded extends BannerState {
  final List<BannerModel> banners;
  BannerLoaded(this.banners);
  @override
  List<Object?> get props => [banners];
}

class BannerTitleExists extends BannerState {}

class BannerTitleAvailable extends BannerState {}
