import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'order-state.dart';

class OrderCubit extends Cubit<OrderState> {
  static OrderCubit get(BuildContext context) => BlocProvider.of(context);

  OrderCubit() : super(OrderInitial());
  changeRebuild() {
    emit(OrderChange());
  }

  // =================== UI Helpers ====================
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

  // =================== Orders ====================
  OrdersModel? _orders;
  OrdersModel? get orders => _orders;

  List<Data>? currentOrders;
  List<Data>? oldOrders;

  ApiResponse _ordersResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );

  ApiResponse get ordersResponse => _ordersResponse;

  Future<void> getOrders(int orderStatus) async {
    emit(OrderLoading());

    // ✅ لا تجلب البيانات من الـ API إن كانت موجودة مسبقاً
    if (orderStatus == 1 && currentOrders != null) {
      _orders = OrdersModel(data: currentOrders);
      emit(OrderSuccess(ordersModel: _orders));
      return;
    }

    if (orderStatus == 0 && oldOrders != null) {
      _orders = OrdersModel(data: oldOrders);
      emit(OrderSuccess(ordersModel: _orders));
      return;
    }

    _ordersResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );

    emit(OrderLoading());

    _ordersResponse = await ApiHelper.instance.get(
      Urls.orders(orderStatus),
    );

    emit(OrderChange());

    if (_ordersResponse.state == ResponseState.complete) {
      final result = OrdersModel.fromJson(_ordersResponse.data);
      _orders = result;

      if (orderStatus == 1) {
        currentOrders = result.data ?? [];
      } else {
        oldOrders = result.data ?? [];
      }

      emit(OrderSuccess(ordersModel: result));
    } else if (_ordersResponse.state == ResponseState.unauthorized) {
      emit(OrderError());
    }
  }

  void initialOrders() {
    _ordersResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _orders = null;
    currentOrders = null;
    oldOrders = null;
    emit(OrderChange());
  }

  // =================== Nearby Providers ====================
  Future<void> getNearbyProviders({
    required int catigoryId,
    required int addressId,
    required VoidCallback onSuccess,
  }) async {
    NavigatorMethods.loading();
    FormData body =
        FormData.fromMap({'product_id': catigoryId, 'address_id': addressId});
    final response = await ApiHelper.instance.post(
      Urls.getNearbyProviders,
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (response.state == ResponseState.complete) {
      onSuccess.call();
    } else if (response.state == ResponseState.unauthorized) {
      CommonMethods.showAlertDialog(
        message: tr(AppLocaleKey.youMustLogInFirst),
      );
    } else {
      CommonMethods.showError(
        message: response.data['message'] ?? 'حدث خطأ',
        apiResponse: response,
      );
    }
  }

  // =================== Create Order ====================
  Future<void> createOrder({
    required int catigoryId,
    required int serviceProviderId,
    required int priceId,
    required int addressId,
    required String fromDate,
    required double totalPrice,
    required double price,
    required double vatValue,
    required VoidCallback onSuccess,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'product_id': catigoryId,
      'address_id': addressId,
      "service_provider_id": serviceProviderId,
      "price_id": priceId,
      "from_date": fromDate,
      "total_price": totalPrice,
      "price": price,
      "vat_value": vatValue
    });
    final response = await ApiHelper.instance.post(
      Urls.createOrder,
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (response.state == ResponseState.complete) {
      onSuccess.call();
    } else if (response.state == ResponseState.unauthorized) {
      CommonMethods.showAlertDialog(
        message: tr(AppLocaleKey.youMustLogInFirst),
      );
    } else {
      CommonMethods.showError(
        message: response.data['message'] ?? 'حدث خطأ',
        apiResponse: response,
      );
    }
  }
}
