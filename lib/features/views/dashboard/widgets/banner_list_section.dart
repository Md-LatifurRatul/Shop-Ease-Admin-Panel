import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/config/app_router.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_bloc.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_event.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_state.dart';
import 'package:shop_ease_admin/widgets/confirm_alert.dart';
import 'package:shop_ease_admin/widgets/snack_message.dart';

class BannerListSection extends StatefulWidget {
  const BannerListSection({super.key});

  @override
  State<BannerListSection> createState() => _BannerListSectionState();
}

class _BannerListSectionState extends State<BannerListSection> {
  @override
  void initState() {
    super.initState();
    context.read<BannerBloc>().add(FetchBannersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Banners",
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 160,
          child: BlocBuilder<BannerBloc, BannerState>(
            builder: (context, state) {
              if (state is BannerLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BannerLoaded) {
                final banners = state.banners;
                if (banners.isEmpty) {
                  return const Center(child: Text("No banners found."));
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(20),
                  itemCount: banners.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey.shade300,
                                child:
                                    banner.imageUrl.isNotEmpty
                                        ? Image.network(
                                          banner.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => Icon(
                                                Icons.broken_image,
                                                size: 40,
                                              ),
                                        )
                                        : Icon(
                                          Icons.image,
                                          size: 40,
                                          color: Colors.grey.shade600,
                                        ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      banner.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        AppRouter.editBanner,
                                        arguments: banner,
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
                                        title: "Delete Banner",
                                        content:
                                            'Are you sure you want to delete?',
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<BannerBloc>().add(
                                            DeleteBannerEvent(banner.id),
                                          );
                                          SnackMessage.showSnackMessage(
                                            context,
                                            "Banner deleted!",
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is BannerFailure) {
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
