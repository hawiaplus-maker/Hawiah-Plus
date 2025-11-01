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
int _currentPage = 1;
int _lastPage = 1;
bool _isLoadingMore = false;

bool get canLoadMore => _currentPage < _lastPage;

  ApiResponse get ordersResponse => _ordersResponse;

Future<void> getOrders({
  required int orderStatus,
  int page = 1,
  bool isLoadMore = false,
}) async {
  if (isLoadMore && _isLoadingMore) return; // منع تكرار الطلب
  if (isLoadMore) _isLoadingMore = true;

  emit(OrderLoading());

  final response = await ApiHelper.instance.get(
    Urls.orders(orderStatus),
    queryParameters: {
      "order_status": orderStatus,
      "page": page,
    },
  );

  if (response.state == ResponseState.complete) {
 
  final result = OrdersModel.fromJson(response.data);
final newOrders = result.data?.data ?? [];
final pagination = result.data?.pagination;


    if (!isLoadMore) {
      _orders = result;
      _currentPage = pagination?.currentPage ?? 1;
      _lastPage = pagination?.lastPage ?? 1;

      if (orderStatus == 0) {
        currentOrders = newOrders;
      } else {
        oldOrders = newOrders;
      }
    } else {
      _currentPage++;
      if (orderStatus == 0) {
        currentOrders?.addAll(newOrders);
      } else {
        oldOrders?.addAll(newOrders);
      }
    }

    emit(OrderSuccess(ordersModel: _orders!));
  } else if (response.state == ResponseState.unauthorized) {
    emit(OrderError());
  } else {
    emit(OrderError());
  }

  if (isLoadMore) _isLoadingMore = false;
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
  ApiResponse get nearbyServiceProviderResponse => _nearbyServiceProviderResponse;

  List<NearbyServiceProviderModel> _nearbyServiceProvider = [];

  List<NearbyServiceProviderModel> get nearbyServiceProvider => _nearbyServiceProvider;

  Future<void> getNearbyProviders({
    required int serviceProviderId,
    required int addressId,
    VoidCallback? onBadRequest,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({'product_id': serviceProviderId, 'address_id': addressId});
    _nearbyServiceProviderResponse = await ApiHelper.instance.post(
      Urls.getNearbyProviders,
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (_nearbyServiceProviderResponse.state == ResponseState.complete) {
      Iterable iterable = _nearbyServiceProviderResponse.data['data'];
      _nearbyServiceProvider = iterable.map((e) => NearbyServiceProviderModel.fromJson(e)).toList();
      emit(OrderChange());
    } else if (_nearbyServiceProviderResponse.state == ResponseState.unauthorized) {
      CommonMethods.showAlertDialog(
        message: tr(AppLocaleKey.youMustLogInFirst),
      );
    } else if (_nearbyServiceProviderResponse.state == ResponseState.badRequest) {
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

  // =================== Create Order ====================
  Future<void> createOrder({
    required int serviceProviderId,
    required int priceId,
    required int addressId,
    required String fromDate,
    required VoidCallback onSuccess,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'product_id': serviceProviderId,
      "price_id": priceId,
      'address_id': addressId,
      "from_date": fromDate,
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
        message: response.data['message'] ?? 'حدث خطأ',
        apiResponse: response,
      );
    }
  }

  // =================== repeat Order ====================

  Future<void> repeatOrder({
    required int orderId,
    required String fromDate,
    required VoidCallback onSuccess,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'order_id': orderId,
      "from_date": fromDate,
    });
    final response = await ApiHelper.instance.post(
      Urls.repeateOrder,
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
        message: response.data['message'] ?? 'حدث خطأ',
        apiResponse: response,
      );
    }
  }

  // =================== get payment link ====================
  Future<void> getPaymentLink({
    required int orderId,
    required Function(String) onSuccess,
  }) async {
    NavigatorMethods.loading();
    final response = await ApiHelper.instance.get(
      Urls.payment(orderId),
    );
    NavigatorMethods.loadingOff();
    if (response.state == ResponseState.complete) {
      onSuccess.call(response.data['payment_url']);
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
