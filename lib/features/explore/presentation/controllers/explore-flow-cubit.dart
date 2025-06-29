import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/features/explore/presentation/controllers/explore-flow-state.dart';

class ExploreFlowCubit extends Cubit<ExploreFlowState> {
  static ExploreFlowCubit get(BuildContext context) => BlocProvider.of(context);

  ExploreFlowCubit() : super(ExploreFlowInitial());
  String? languageSelected;

  changeRebuild() {
    emit(ExploreFlowRebuild());
  }

  List<HawiahCategoryModel> categories = [
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "سطحات",
      info: "سطحات لتسهيل نقل البضائع الثقيلة والضخمة.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "حاويات",
      info: "حاويات متنوعة لحفظ وشحن البضائع بأمان.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "بضائع",
      info: "خدمات نقل وتوزيع البضائع المختلفة.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "مركبات",
      info: "نقل السيارات والمركبات بمختلف أنواعها بأمان.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "معدات ثقيلة",
      info: "نقل المعدات الثقيلة مثل الرافعات والآلات الصناعية.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "مواد بناء",
      info: "نقل مواد البناء مثل الإسمنت والطوب والحديد.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "منتجات زراعية",
      info: "نقل وتوزيع المنتجات الزراعية الطازجة.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "منتجات غذائية",
      info: "نقل المواد الغذائية بسرعة للحفاظ على جودتها.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "بضائع سريعة التلف",
      info: "خدمات نقل سريعة للبضائع التي تتطلب ظروف تخزين خاصة.",
    ),
    HawiahCategoryModel(
      logo: "assets/images/car_image.png",
      title: "منتجات إلكترونية",
      info: "نقل الأجهزة الإلكترونية بكفاءة لضمان سلامتها.",
    ),
  ];
  String? selectedCategory;
  void changeCategory(String category) {
    selectedCategory = category;
    emit(ExploreFlowChange());
  }

  List<String> categoriesExplore = [
    "warehouse",
    "box",
  ];
  String? selectedCategoryExplore;
  void changeCategoryExplore(String? value) {
    selectedCategoryExplore = value;
    emit(ExploreFlowChange());
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
  String? selectedCar;
  void changeCar(String? value) {
    selectedCar = value;
    emit(ExploreFlowChange());
  }

}

class HawiahCategoryModel {
  String logo;
  String title;
  String info;

  HawiahCategoryModel({
    required this.logo,
    required this.title,
    required this.info,
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

