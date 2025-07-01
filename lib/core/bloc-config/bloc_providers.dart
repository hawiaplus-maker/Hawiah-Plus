import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/features/app-language/presentation/controllers/app-language-cubit/app-language-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/explore/presentation/controllers/explore-flow-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/on-boarding/presentation/controllers/on-boarding-cubit/on-boarding-cubit.dart';
import 'package:hawiah_client/features/order/presentation/controllers/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class BlocProviders {
  static List<BlocProvider> blocs() {
    return <BlocProvider>[
      BlocProvider<AppLanguageCubit>(
        create: (context) => sl<AppLanguageCubit>(),
      ),
      BlocProvider<OnBoardingCubit>(
        create: (context) => sl<OnBoardingCubit>(),
      ),
      BlocProvider<AuthCubit>(
        create: (context) => sl<AuthCubit>(),
      ),
      BlocProvider<HomeCubit>(
        create: (context) => sl<HomeCubit>(),
      ),
      BlocProvider<ExploreFlowCubit>(
        create: (context) => sl<ExploreFlowCubit>(),
      ),
      BlocProvider<OrderCubit>(
        create: (context) => sl<OrderCubit>(),
      ),
      BlocProvider<OrderCubit>(
        create: (context) => sl<OrderCubit>(),
      ),
      BlocProvider<SettingCubit>(
        create: (context) => sl<SettingCubit>())
    ];
  }
}
