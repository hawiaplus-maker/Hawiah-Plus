import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_shimmer.dart';
import 'package:hawiah_client/features/home/presentation/widgets/best_seller_widget.dart';

import '../controllers/home-services-cubit/home-services-cubit.dart';
import '../controllers/home-services-cubit/home-services-state.dart';

class BestsellerListWidget extends StatefulWidget {
  const BestsellerListWidget({super.key});

  @override
  State<BestsellerListWidget> createState() => _BestsellerListWidgetState();
}

class _BestsellerListWidgetState extends State<BestsellerListWidget> {
  bool expanded = false;

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeServicesCubit, HomeServicesState>(
      builder: (context, state) {
        final homeServicesCubit = context.read<HomeServicesCubit>();

        final list = homeServicesCubit.services?.message ?? [];
        final int itemCount = expanded ? list.length : list.length.clamp(0, 4);

        return ApiResponseWidget(
          apiResponse: homeServicesCubit.servicesResponse,
          onReload: () async => homeServicesCubit.getServices(),
          isEmpty: list.isEmpty,
          loadingWidget: Padding(
            padding: const EdgeInsets.all(14.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: .74,
              ),
              itemBuilder: (context, index) => CustomShimmer(radius: 12),
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: .8,
            ),
            itemBuilder: (context, index) {
              final item = list[index];
              return BestSellerWidgt(
                item: item,
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
