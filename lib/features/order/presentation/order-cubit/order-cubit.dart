import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/model/nearby_service-provider_model.dart';
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

  //================== get nearby provider ====================
  void initialNearbyServiceProvider() {
    _nearbyServiceProviderResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _nearbyServiceProvider = [];
    emit(OrderChange());
  }

  ApiResponse _nearbyServiceProviderResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get nearbyServiceProviderResponse =>
      _nearbyServiceProviderResponse;

  List<NearbyServiceProviderModel> _nearbyServiceProvider = [];

  List<NearbyServiceProviderModel> get nearbyServiceProvider =>
      _nearbyServiceProvider;

  Future<void> getNearbyProviders({
    required int serviceProviderId,
    required int addressId,
    VoidCallback? onBadRequest,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap(
        {'product_id': serviceProviderId, 'address_id': addressId});
    _nearbyServiceProviderResponse = await ApiHelper.instance.post(
      Urls.getNearbyProviders,
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (_nearbyServiceProviderResponse.state == ResponseState.complete) {
      Iterable iterable = _nearbyServiceProviderResponse.data['data'];
      _nearbyServiceProvider =
          iterable.map((e) => NearbyServiceProviderModel.fromJson(e)).toList();
      emit(OrderChange());
    } else if (_nearbyServiceProviderResponse.state ==
        ResponseState.unauthorized) {
      CommonMethods.showAlertDialog(
        message: tr(AppLocaleKey.youMustLogInFirst),
      );
    } else if (_nearbyServiceProviderResponse.state ==
        ResponseState.badRequest) {
      CommonMethods.showError(
        message: _nearbyServiceProviderResponse.data['message'] ?? 'حدث خطاء',
        apiResponse: _nearbyServiceProviderResponse,
      );
      onBadRequest?.call();
    } else {
      CommonMethods.showError(
        message: _nearbyServiceProviderResponse.data['message'] ?? 'حدث خطاء',
        apiResponse: _nearbyServiceProviderResponse,
      );
    }
  }
  //?================== create order ====================

  Future<void> createOrder(
      {required int catigoryId,
      required int serviceProviderId,
      required int priceId,
      required int addressId,
      required String fromDate,
      required double totalPrice,
      required double price,
      required double vatValue,
      required VoidCallback onSuccess}) async {
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
      CommonMethods.showToast(
        message: response.data['message'] ?? "تم انشاء الطلب بنجاح",
      );
      onSuccess.call();
    } else if (response.state == ResponseState.unauthorized) {
      CommonMethods.showAlertDialog(
        message: tr(AppLocaleKey.youMustLogInFirst),
      );
    } else {
      CommonMethods.showError(
        message: response.data['message'] ?? 'حدث خطاء',
        apiResponse: response,
      );
    }
  }
}
