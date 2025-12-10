import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/model/nearby_service-provider_model.dart';
import 'package:hawiah_client/features/order/presentation/model/order_details_model.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'order-state.dart';

class OrderCubit extends Cubit<OrderState> {
  static OrderCubit get(BuildContext context) => BlocProvider.of(context);

  OrderCubit() : super(OrderInitial());
  changeRebuild() {
    emit(OrderChange());
  } // =================== UI Helpers ====================

  bool isOrderCurrent = true;
  void changeOrderCurrent() {
    isOrderCurrent = !isOrderCurrent;
    emit(OrderChange());
  }

// =================== Calendar Stuff ====================
  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

// =================== Orders ====================

// current orders
  List<SingleOrderData> currentOrders = [];
  int currentPageCurrent = 1;
  int lastPageCurrent = 1;
  bool isLoadingCurrent = false;
  bool isLoadingMoreCurrent = false;

// old orders
  List<SingleOrderData> oldOrders = [];
  int currentPageOld = 1;
  int lastPageOld = 1;
  bool isLoadingOld = false;
  bool isLoadingMoreOld = false;

// Helpers
  bool get canLoadMoreCurrent => currentPageCurrent < lastPageCurrent;
  bool get canLoadMoreOld => currentPageOld < lastPageOld;

// =================== Main API Function ====================
  Future<void> getOrders({
    required int orderStatus,
    int page = 1,
    bool isLoadMore = false,
  }) async {
    log("**************************** getOrders($orderStatus) *************************");

    // =================== Check if user is visitor =====================
    if (HiveMethods.isVisitor() || HiveMethods.getToken() == null) {
      emit(Unauthenticated()); // فورًا emit
      return; // وممنوع أي تحميل أكتر
    }

    final bool isCurrent = orderStatus == 0;

    // // =================== Prevent Re-fetching =====================
    // if (!isLoadMore) {
    //   if (isCurrent) {
    //     emit(OrderSuccess(
    //       ordersModel: OrdersModel(
    //         data: OrdersData(
    //           data: currentOrders,
    //           pagination: Pagination(
    //             currentPage: currentPageCurrent,
    //             lastPage: lastPageCurrent,
    //           ),
    //         ),
    //       ),
    //     ));
    //     return;
    //   }

    //   if (!isCurrent) {
    //     emit(OrderSuccess(
    //       ordersModel: OrdersModel(
    //         data: OrdersData(
    //           data: oldOrders,
    //           pagination: Pagination(
    //             currentPage: currentPageOld,
    //             lastPage: lastPageOld,
    //           ),
    //         ),
    //       ),
    //     ));
    //     return;
    //   }
    // }
    // =================== Load =====================
    if (isLoadMore) {
      if (isCurrent ? isLoadingMoreCurrent : isLoadingMoreOld) return;
      if (isCurrent) {
        isLoadingMoreCurrent = true;
      } else {
        isLoadingMoreOld = true;
      }
      emit(OrderPaginationLoading());
    } else {
      if (isCurrent) {
        isLoadingCurrent = true;
      } else {
        isLoadingOld = true;
      }
      emit(OrderLoading());
    }

    // =================== API =====================
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

      if (isCurrent) {
        currentPageCurrent = pagination?.currentPage ?? 1;
        lastPageCurrent = pagination?.lastPage ?? 1;
      } else {
        currentPageOld = pagination?.currentPage ?? 1;
        lastPageOld = pagination?.lastPage ?? 1;
      }

      if (isLoadMore) {
        if (isCurrent) {
          currentOrders.addAll(newOrders);
          isLoadingMoreCurrent = false;
        } else {
          oldOrders.addAll(newOrders);
          isLoadingMoreOld = false;
        }
      } else {
        if (isCurrent) {
          currentOrders = newOrders;
          isLoadingCurrent = false;
        } else {
          oldOrders = newOrders;
          isLoadingOld = false;
        }
      }

      emit(OrderSuccess(ordersModel: result));
    } else if (response.state == ResponseState.unauthorized) {
      if (state != Unauthenticated()) emit(Unauthenticated());
    } else {
      if (isCurrent) {
        isLoadingCurrent = false;
        isLoadingMoreCurrent = false;
      } else {
        isLoadingOld = false;
        isLoadingMoreOld = false;
      }
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
    required String fromTime,
    required Function(OrderDetailsModel? order) onSuccess,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'product_id': serviceProviderId,
      "price_id": priceId,
      'address_id': addressId,
      "from_date": fromDate,
      "from_time": fromTime,
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
      onSuccess.call(
          response.data['data'] != null ? OrderDetailsModel.fromJson(response.data['data']) : null);
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

// =================== empty-order ====================
  Future<void> emptyOrder({
    required int orderId,
    required VoidCallback onSuccess,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'order_id': orderId,
    });
    final response = await ApiHelper.instance.post(
      Urls.emptyOrder,
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(
        message: response.data['message'] ?? "تم افراغ الطلب بنجاح",
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

  // =================== rate-Diver ====================
  Future<void> rateDiver({
    int? orderId,
    required int rate,
    required int serviceProviderId,
    String? message,
    required VoidCallback onSuccess,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'service_provider_id': serviceProviderId,
      'rating': rate,
      'order_id': orderId,
      'message': message
    });
    final response = await ApiHelper.instance.post(
      Urls.rateDiver,
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(
        message: response.data['message'] ?? "تم التقييم بنجاح",
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
      final paymentUrl = response.data['payment_url'];

      if (paymentUrl == null || paymentUrl is! String) {
        CommonMethods.showError(
          message: "خطأ في رابط الدفع من السيرفر",
        );
        return;
      }

      final url = paymentUrl.trim();

      final bool looksLikeJsonError = url.startsWith("{") && url.endsWith("}");

      if (looksLikeJsonError) {
        CommonMethods.showError(
          message: "خطأ في الدفع: ${url}",
        );
        return;
      }

      if (!url.startsWith("http")) {
        CommonMethods.showError(message: "رابط الدفع غير صالح");
        return;
      }

      onSuccess.call(url);
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

  // =================== applay coupon ====================
  Future<void> applyCoupon({
    required String code,
    required int orderId,
    dynamic Function(String discountValue, int discount, String priceAfterDiscount, String copone)?
        onSuccess,
  }) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'code': code,
      'order_id': orderId,
    });
    final response = await ApiHelper.instance.post(
      Urls.applayCoupon,
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (response.state == ResponseState.complete && response.data['success'] != false) {
      CommonMethods.showToast(
        message: response.data['message'] ?? "تم  بنجاح",
      );
      onSuccess?.call(
        response.data['discount_amount'].toString(),
        response.data['discount_percent'],
        response.data['price_after_discount'].toString(),
        response.data['code'].toString(),
      );
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
