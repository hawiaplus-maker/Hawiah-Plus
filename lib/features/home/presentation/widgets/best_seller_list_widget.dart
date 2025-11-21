import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_shimmer.dart';
import 'package:hawiah_client/features/home/presentation/widgets/best_seller_widget.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class BestsellerListWidget extends StatefulWidget {
  const BestsellerListWidget({super.key});

  @override
  State<BestsellerListWidget> createState() => _BestsellerListWidgetState();
}

class _BestsellerListWidgetState extends State<BestsellerListWidget> {
  bool expanded = false;
  void initState() {
    super.initState();

    final homeCubit = HomeCubit.get(context);
    homeCubit.getBestSeller();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      final homeCubit = HomeCubit.get(context);

      final list = homeCubit.bestSeller;
      final int itemCount = expanded ? list.length : list.length.clamp(0, 4);

      return ApiResponseWidget(
        apiResponse: homeCubit.bestSellerResponse,
        onReload: () async => homeCubit.getBestSeller(),
        isEmpty: homeCubit.bestSeller.isEmpty,
        loadingWidget: Padding(
          padding: const EdgeInsets.all(14.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: .74,
            ),
            itemBuilder: (context, index) => CustomShimmer(
              radius: 12,
            ),
          ),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: .74,
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
    });
  }
}
