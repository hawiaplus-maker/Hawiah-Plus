import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'order-state.dart';

class OrderCubit extends Cubit<OrderState> {
  static OrderCubit get(BuildContext context) => BlocProvider.of(context);

  OrderCubit() : super(OrderInitial());

  bool isOrderCurrent = true;

  OrdersModel? _currentOrders;
  OrdersModel? _oldOrders;

  OrdersModel? _orders;
  OrdersModel? get orders => _orders;

  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  void changeRebuild() => emit(OrderChange());

  void changeOrderCurrent(bool value) {
    isOrderCurrent = value;
    _orders = isOrderCurrent ? _currentOrders : _oldOrders;
    emit(OrderChange());
  }

  void initialOrders() {
    _currentOrders = null;
    _oldOrders = null;
    _orders = null;
    emit(OrderChange());
  }

  Future<void> getOrders(int orderStatus) async {
    if (orderStatus == 1 && _currentOrders != null) {
      _orders = _currentOrders;
      emit(OrderSuccess(ordersModel: _orders!));
      return;
    } else if (orderStatus == 0 && _oldOrders != null) {
      _orders = _oldOrders;
      emit(OrderSuccess(ordersModel: _orders!));
      return;
    }

    emit(OrderLoading());

    final response = await ApiHelper.instance.get(Urls.orders(orderStatus));

    if (response.state == ResponseState.complete) {
      final result = OrdersModel.fromJson(response.data);
      _orders = result;

      if (orderStatus == 1) {
        _currentOrders = result;
      } else {
        _oldOrders = result;
      }

      emit(OrderSuccess(ordersModel: result));
    } else {
      emit(OrderError());
    }
  }
}
