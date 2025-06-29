import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'order-state.dart';

class OrderCubit extends Cubit<OrderState> {
  static OrderCubit get(BuildContext context) => BlocProvider.of(context);

  OrderCubit() : super(OrderInitial());

  changeRebuild() {
    emit(OrderChange());
  }

  List<OrderModel> orderList = [
    OrderModel(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      size: "صغير",
      title: "حاوية طبية",
      logo: "assets/images/car_image.png",
    ),
    OrderModel(
      date: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 1))),
      size: "متوسط",
      title: "حاوية صناعية",
      logo: "assets/images/car_image.png",
    ),
    OrderModel(
      date: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 2))),
      size: "كبير",
      title: "حاوية منزلية",
      logo: "assets/images/car_image.png",
    ),
    OrderModel(
      date: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 3))),
      size: "صغير",
      title: "حاوية طبية",
      logo: "assets/images/car_image.png",
    ),
    OrderModel(
      date: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 4))),
      size: "متوسط",
      title: "حاوية تجارية",
      logo: "assets/images/car_image.png",
    ),
  ];
  bool isOrderCurrent = true;

  void changeOrderCurrent() {
    isOrderCurrent = !isOrderCurrent;
    emit(OrderChange());
  }

  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
}

class OrderModel {
  String title;
  String logo;
  String size;
  String date;

  OrderModel({
    required this.title,
    required this.logo,
    required this.size,
    required this.date,
  });
}
