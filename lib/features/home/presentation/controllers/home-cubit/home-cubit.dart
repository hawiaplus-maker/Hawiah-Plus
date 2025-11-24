import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/model/categories_model.dart';
import 'package:hawiah_client/features/home/presentation/model/services_model.dart';
import 'package:hawiah_client/features/home/presentation/model/show_categories_model.dart';
import 'package:hawiah_client/features/home/presentation/model/slider_model.dart';
import 'package:hawiah_client/features/location/presentation/model/quick_selection_card_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'home-state.dart';

class HomeCubit extends Cubit<HomeState> {
  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  HomeCubit() : super(HomeInitial());
  String? languageSelected;

  List<String> categorieS = [
    "warehouse",
    "box",
  ];
  String? selectedCategory;

  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  int selectedIndex = -1;
  List<QuickSelectionCardModel> quickList = [
    QuickSelectionCardModel(day: AppLocaleKey.threeDays.tr(), days: 3),
    QuickSelectionCardModel(day: AppLocaleKey.week.tr(), days: 7),
    QuickSelectionCardModel(day: AppLocaleKey.twoWeeks.tr(), days: 14),
    QuickSelectionCardModel(day: AppLocaleKey.month.tr(), days: 30),
    QuickSelectionCardModel(day: AppLocaleKey.twoMonths.tr(), days: 60),
    QuickSelectionCardModel(day: AppLocaleKey.threeMonths.tr(), days: 90),
  ];
  void clearRanges() {
    rangeStart = null;
    rangeEnd = null;
  }

  changeRebuild() {
    emit(HomeChange());
  }

  void setRangeStart(DateTime start, int days) {
    rangeStart = start;
    rangeEnd = start.add(Duration(days: days));
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    changeRebuild();
  }

  void initialInHomeSliders() {
    _homeSlidersResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );

    emit(HomeChange());
  }

  ApiResponse _homeSlidersResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get homeSlidersResponse => _homeSlidersResponse;

  List<SliderModel> _homeSliders = [];
  List<SliderModel> get homeSliders => _homeSliders;
  Future<void> getHomeSliders() async {
    _homeSlidersResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _homeSliders = [];
    emit(HomeChange());

    _homeSlidersResponse = await ApiHelper.instance.get(
      Urls.sliders,
    );

    if (homeSlidersResponse.state == ResponseState.complete && _homeSlidersResponse.data != null) {
      Iterable iterable = _homeSlidersResponse.data['data'];
      _homeSliders = iterable.map((e) => SliderModel.fromJson(e)).toList();

      emit(HomeChange());
    } else if (_homeSlidersResponse.state == ResponseState.unauthorized) {
      emit(HomeChange());
    }
  }

  //********************************services********************* */
  void initialservices() {
    _servicesResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _services = null;
    emit(HomeChange());
  }

  ApiResponse _servicesResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get servicesResponse => _servicesResponse;

  ServicesModel? _services;
  ServicesModel? get services => _services;
  Future<void> getservices() async {
    _servicesResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _services = null;
    emit(HomeChange());

    _servicesResponse =
        await ApiHelper.instance.get(Urls.services, queryParameters: {"best_seller": 1});

    if (_servicesResponse.state == ResponseState.complete && _servicesResponse.data != null) {
      _services = ServicesModel.fromJson(_servicesResponse.data);
      emit(HomeChange());
    } else if (_servicesResponse.state == ResponseState.unauthorized) {
      emit(HomeChange());
    }
  }

  ///**************************categories************************ */
  void initialCategories() {
    _categoriesResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _categories = [];
    emit(HomeChange());
  }

  ApiResponse _categoriesResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get categoriesResponse => _categoriesResponse;

  List<SingleCategoryModel> _categories = [];
  List<SingleCategoryModel> get categories => _categories;
  Future<void> getCategories({bool? inHome}) async {
    _categoriesResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _categories = [];
    emit(HomeChange());

    _categoriesResponse = await ApiHelper.instance.get(Urls.categories, queryParameters: {
      if (inHome == true) "show_on_main_page": 1,
    });

    if (categoriesResponse.state == ResponseState.complete && _categoriesResponse.data != null) {
      Iterable iterable = _categoriesResponse.data['message'];
      _categories = iterable.map((e) => SingleCategoryModel.fromJson(e)).toList();
      emit(HomeChange());
    } else if (_categoriesResponse.state == ResponseState.unauthorized) {
      emit(HomeChange());
    }
  }

  void initialbestSeller() {
    _bestSellerResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _bestSeller = [];
    emit(HomeChange());
  }

  ApiResponse _bestSellerResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get bestSellerResponse => _bestSellerResponse;

  List<SingleCategoryModel> _bestSeller = [];
  List<SingleCategoryModel> get bestSeller => _bestSeller;
  Future<void> getBestSeller({bool? inHome}) async {
    _bestSellerResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _bestSeller = [];
    emit(HomeChange());

    _bestSellerResponse =
        await ApiHelper.instance.get(Urls.categories, queryParameters: {"best_seller": 1});

    if (bestSellerResponse.state == ResponseState.complete && _bestSellerResponse.data != null) {
      Iterable iterable = _bestSellerResponse.data['message'];
      _bestSeller = iterable.map((e) => SingleCategoryModel.fromJson(e)).toList();
      emit(HomeChange());
    } else if (_bestSellerResponse.state == ResponseState.unauthorized) {
      emit(HomeChange());
    }
  }

  //*======================== in home category ===================

  void initialInHomeCategories() {
    _homeCategoriesResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );

    emit(HomeChange());
  }

  ApiResponse _homeCategoriesResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get homeCategoriesResponse => _homeCategoriesResponse;

  List<SingleCategoryModel> _homeCategories = [];
  List<SingleCategoryModel> get homeCategorieS => _homeCategories;
  Future<void> getHomeCategories() async {
    _homeCategoriesResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _homeCategories = [];
    emit(HomeChange());

    _homeCategoriesResponse =
        await ApiHelper.instance.get(Urls.categories, queryParameters: {"show_on_main_page": 1});

    if (homeCategoriesResponse.state == ResponseState.complete &&
        _homeCategoriesResponse.data != null) {
      Iterable iterable = _homeCategoriesResponse.data['message'];
      _homeCategories = iterable.map((e) => SingleCategoryModel.fromJson(e)).toList();

      emit(HomeChange());
    } else if (_homeCategoriesResponse.state == ResponseState.unauthorized) {
      emit(HomeChange());
    }
  }

  //**************************categories************************ */
  void initialShowCategories() {
    _showCategoriesResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _showCategories = null;
    emit(HomeChange());
  }

  ApiResponse _showCategoriesResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get showCategoriesResponse => _showCategoriesResponse;

  ShowCategoriesModel? _showCategories;
  ShowCategoriesModel? get showCategories => _showCategories;
  Future<void> getshowCategories(
    int id, {
    VoidCallback? onSuccess,
  }) async {
    if (onSuccess != null) NavigatorMethods.loading();
    _showCategoriesResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _showCategories = null;
    emit(HomeChange());

    _showCategoriesResponse = await ApiHelper.instance.get(Urls.showCategory(id));
    if (onSuccess != null) NavigatorMethods.loadingOff();
    if (_showCategoriesResponse.state == ResponseState.complete &&
        _showCategoriesResponse.data != null) {
      _showCategories = ShowCategoriesModel.fromJson(_showCategoriesResponse.data);
      if (_showCategories?.message?.services?.isNotEmpty ?? false) {
        onSuccess?.call();
      } else {
        CommonMethods.showError(message: "لا يوجد خدمات");
      }

      emit(HomeChange());
    } else if (_showCategoriesResponse.state == ResponseState.unauthorized) {
      emit(HomeChange());
    }
  }
}

class TransportationCategoryModel {
  String title;
  String logo;

  TransportationCategoryModel({
    required this.title,
    required this.logo,
  });
}

class CarModel {
  String title;
  String logo;
  List<String> sizes;
  double pricePerDay;
  double distanceFromLocation;

  CarModel({
    required this.title,
    required this.logo,
    required this.sizes,
    required this.pricePerDay,
    required this.distanceFromLocation,
  });
}
