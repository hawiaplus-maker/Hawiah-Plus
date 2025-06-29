import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/features/app-language/presentation/controllers/app-language-cubit/app-language-state.dart';

class AppLanguageCubit extends Cubit<AppLanguageState> {
  static AppLanguageCubit get(BuildContext context) => BlocProvider.of(context);

  AppLanguageCubit() : super(AppLanguageInitial());
  String? languageSelected;

  changeLanguage({required String language}) {
    languageSelected = language;

    emit(AppLanguageChange());
  }

  changeRebuild() {
    emit(AppLanguageRebuild());
  }

  List<String> languages = ["arabic", "english", "french", "german", "spanish"];
}

class MyOrdersModel {
  String serviceName;
  String serviceType;
  String serviceDate;
  String companyName;
  double companyRating;
  String companyLogo;

  MyOrdersModel({
    required this.serviceName,
    required this.serviceType,
    required this.serviceDate,
    required this.companyName,
    required this.companyRating,
    required this.companyLogo,
  });
}
