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

  changeRebuild() {
    emit(OrderChange());
  }

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
  void initialOrders() {
    _ordersResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _orders = null;
    emit(OrderChange());
  }

  ApiResponse _ordersResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get ordersResponse => _ordersResponse;

  OrdersModel? _orders;
  OrdersModel? get orders => _orders;

  Future<void> getOrders(int orderStatus) async {
    emit(OrderLoading());
    _ordersResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );
    _orders = null;
    emit(OrderLoading());
    _ordersResponse = await ApiHelper.instance.get(
      Urls.orders(orderStatus),
    );
    emit(OrderChange());

    if (_ordersResponse.state == ResponseState.complete) {
      _orders = OrdersModel.fromJson(_ordersResponse.data);
      emit(OrderSuccess(ordersModel: _orders));
    } else if (_ordersResponse.state == ResponseState.unauthorized) {
      emit(OrderError());
    }
  }
}
