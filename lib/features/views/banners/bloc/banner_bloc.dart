import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/data/repositories/banner_repository.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_event.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository repository;

  BannerBloc(this.repository) : super(BannerInitial()) {
    on<AddBannerEvent>((event, emit) async {
      emit(BannerLoading());

      try {
        final banner = await repository.addBanner(event.banner);
        emit(BannerLocalSuccess(banner));
      } catch (e) {
        emit(BannerFailure(e.toString()));
      }
    });

    on<FetchBannersEvent>((event, emit) async {
      emit(BannerLoading());
      try {
        final banners = await repository.fetchBanners();
        emit(BannerLoaded(banners));
      } catch (e) {
        emit(BannerFailure(e.toString()));
      }
    });

    on<UpdateBannerEvent>((event, emit) async {
      emit(BannerLoading());
      try {
        final updatedBanner = await repository.updateBanner(
          id: event.id,
          title: event.title,
          imageBytes: event.imageBytes,
        );
        emit(BannerSuccess(updatedBanner));
      } catch (e) {
        emit(BannerFailure(e.toString()));
      }
    });

    on<DeleteBannerEvent>((event, emit) async {
      emit(BannerLoading());

      try {
        await repository.deleteBanner(event.id);
        final banners = await repository.fetchBanners();
        emit(BannerLoaded(banners));
      } catch (e) {
        emit(BannerFailure(e.toString()));
      }
    });
  }
}
