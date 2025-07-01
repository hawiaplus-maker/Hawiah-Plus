import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/home/presentation/model/services_model.dart';
import 'package:hawiah_client/features/home/presentation/model/show_services_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'home-state.dart';

class HomeCubit extends Cubit<HomeState> {
  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  HomeCubit() : super(HomeInitial());
  String? languageSelected;

  changeRebuild() {
    emit(HomeChange());
  }

  List<TransportationCategoryModel> transportationCategoriesList = [
    TransportationCategoryModel(
        title: "سطحة", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "نقل بضاعة", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "سيارات", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "شاحنات", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "معدات ثقيلة", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "نقل أغراض منزلية", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "نقل الأثاث", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "نقل مواد بناء", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "نقل سيارات", logo: "assets/images/car_image.png"),
    TransportationCategoryModel(
        title: "نقل بضائع ثقيلة", logo: "assets/images/car_image.png"),
  ];

  List<String> categories = [
    "warehouse",
    "box",
  ];
  String? selectedCategory;

  List<String> hawaiaList = ["حاوية مباني", "حاوية طبية"];
  String? selectedHawaia;

  void changeHawaia(String? value) {
    selectedHawaia = value;
    emit(HomeRebuild());
  }

  void changeCategory(String? value) {
    selectedCategory = value;
    emit(HomeRebuild());
  }

  List<CarModel> carList = [
    CarModel(
      title: 'Toyota Corolla',
      sizes: ['Small', 'Medium', 'Large'],
      pricePerDay: 250.0,
      distanceFromLocation: 2.5,
      logo: 'assets/images/car_image.png',
    ),
    CarModel(
        title: 'Honda Civic',
        sizes: ['Small', 'Medium'],
        pricePerDay: 300.0,
        distanceFromLocation: 3.0,
        logo: 'assets/images/car_image.png'),
    CarModel(
        title: 'Ford Focus',
        sizes: ['Medium', 'Large'],
        pricePerDay: 280.0,
        distanceFromLocation: 1.8,
        logo: 'assets/images/car_image.png'),
  ];

  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
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
