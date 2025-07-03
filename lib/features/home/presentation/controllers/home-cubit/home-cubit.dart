import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/home/presentation/model/categories_model.dart';
import 'package:hawiah_client/features/home/presentation/model/services_model.dart';
import 'package:hawiah_client/features/home/presentation/model/show_categories_model.dart';
import 'package:hawiah_client/features/home/presentation/model/show_services_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'home-state.dart';

class HomeCubit extends Cubit<HomeState> {
  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  HomeCubit() : super(HomeInitial());
  String? languageSelected;

  List<String> categories = [
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

  changeRebuild() {
    emit(HomeChange());
  }

  void setRangeStart(DateTime start, int days) {
    rangeStart = start;
    rangeEnd = start.add(Duration(days: days));
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    changeRebuild();
  }

  void initialSlider() {
    _sliderResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _slider = null;
    emit(HomeChange());
  }

  ApiResponse _sliderResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get sliderResponse => _sliderResponse;

  ShowservicesModel? _slider;
  ShowservicesModel? get setting => _slider;
  Future<void> getslider() async {
    _sliderResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _slider = null;
    emit(HomeChange());

    _sliderResponse = await ApiHelper.instance.get(Urls.showServices(81));

    if (_sliderResponse.state == ResponseState.complete &&
        _sliderResponse.data != null) {
      _slider = ShowservicesModel.fromJson(_sliderResponse.data);
      emit(HomeChange());
    } else if (_sliderResponse.state == ResponseState.unauthorized) {
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
    _sliderResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _slider = null;
    emit(HomeChange());

    _servicesResponse = await ApiHelper.instance.get(Urls.services);

    if (_servicesResponse.state == ResponseState.complete &&
        _servicesResponse.data != null) {
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
    _services = null;
    emit(HomeChange());
  }

  ApiResponse _categoriesResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get categoriesResponse => _categoriesResponse;

  CategoriesModel? _categories;
  CategoriesModel? get categorieS => _categories;
  Future<void> getCategories() async {
    _sliderResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _slider = null;
    emit(HomeChange());

    _categoriesResponse = await ApiHelper.instance.get(Urls.categories);

    if (categoriesResponse.state == ResponseState.complete &&
        _categoriesResponse.data != null) {
      _categories = CategoriesModel.fromJson(_categoriesResponse.data);
      emit(HomeChange());
    } else if (_categoriesResponse.state == ResponseState.unauthorized) {
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
  ApiResponse get showCategoriesResponse => _sliderResponse;

  ShowCategoriesModel? _showCategories;
  ShowCategoriesModel? get showCategories => _showCategories;
  Future<void> getshowCategories(int id) async {
    _showCategoriesResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _showCategories = null;
    emit(HomeChange());

    _showCategoriesResponse =
        await ApiHelper.instance.get(Urls.showCategory(id));

    if (_showCategoriesResponse.state == ResponseState.complete &&
        _showCategoriesResponse.data != null) {
      _showCategories =
          ShowCategoriesModel.fromJson(_showCategoriesResponse.data);
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
