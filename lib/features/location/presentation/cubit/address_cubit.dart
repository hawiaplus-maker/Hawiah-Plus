import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/model/address_model.dart';

class AddressCubit extends Cubit<AddressState> {
  static AddressCubit get(BuildContext context) => BlocProvider.of(context);

  AddressCubit() : super(AddressInitial());

  changeRebuild() {
    emit(AddressUpdate());
  }

  //====================== Store Address ===================================

  Future<void> storeAddress(
      {required String title,
      required double latitude,
      required double longitude,
      String? address,
      required VoidCallback onSuccess}) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'neighborhood': address,
    });
    final response = await ApiHelper.instance.post(
      Urls.storeAddress,
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: 'تم حفظ العنوان بنجاح');
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

  //*===================================== update address ====================
  Future<void> updateAddress(
      {required String title,
      required double latitude,
      required double longitude,
      required int addressId,
      required VoidCallback onSuccess}) async {
    NavigatorMethods.loading();
    FormData body = FormData.fromMap({
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
    });
    final response = await ApiHelper.instance.put(
      Urls.updateAddress(addressId),
      body: body,
    );
    NavigatorMethods.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: 'تم حفظ العنوان بنجاح');
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

  //*===================================== Get All Address ===================
  void initialaddresses() {
    _addressesResponse = ApiResponse(
      state: ResponseState.sleep,
      data: null,
    );
    _addresses = [];
    emit(AddressUpdate());
  }

  ApiResponse _addressesResponse = ApiResponse(
    state: ResponseState.sleep,
    data: null,
  );
  ApiResponse get addressesResponse => _addressesResponse;
  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;

  Future<void> getaddresses() async {
    _addressesResponse = ApiResponse(
      state: ResponseState.loading,
      data: null,
    );

    _addresses = [];
    emit(AddressUpdate());
    _addressesResponse = await ApiHelper.instance.get(
      Urls.addresses,
    );
    if (_addressesResponse.state == ResponseState.complete) {
      Iterable iterable = _addressesResponse.data['message'];
      _addresses = iterable.map((e) => AddressModel.fromJson(e)).toList();

      emit(AddressUpdate());
    }
  }
}
